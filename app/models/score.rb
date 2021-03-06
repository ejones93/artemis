class Score < ApplicationRecord
  belongs_to :user
  belongs_to :round
  belongs_to :category
  after_initialize :init
  before_validation :set_category
  validates :user_id, presence: true
  validates :round_id, presence: true
  validates :category_id, presence: true
  validates :score, presence: true
  validates :hits, presence: true
  validates :location, presence: true
  validates :bowtype, presence: true
  validates :date, presence: true
  validates :record_status, presence: true
  validate :date_possible?
  validate :score_possible?
  validate :valid_rs?
  before_save :set_hc
  before_save :set_class
  
  private
    def init
      self.golds  ||= 0
      self.xs     ||= 0
      self.record_status ||= "none"
    end
    
    # Check date is not in the future and after users DoB
    def date_possible?
      return if date.blank?
      
      if date > Date.today
        errors.add(:date, "cannot be in the future")
        return false
      elsif date < self.user.date_of_birth
        errors.add(:date, "cannot be before date of birth")
        return false
      else
        return true
      end
    end
    
    # Check default bowtype is an expected value
    def valid_bowtype?
      bowtypes = ["Barebow", "Compound", "Longbow", "Recurve"]
      if bowtypes.include?(bowtype)
        return true
      else
        errors.add(:bowtype, "please pick from the options available")
        return false
      end
    end
    
    # Check record status is an expected value
    def valid_rs?
      statuses = ["none", "ukrs", "wrs"]
      unless statuses.include?(record_status)
        errors.add(:record_status, "please pick from the options available")
      end
    end
    
    # Set category used in the score
    def set_category
      if date_possible? && valid_bowtype? && !user.blank?
        self.category_id = self.user.find_category(bowtype, date)
      end
    end
    
    # Calculate the handicap and assign it 
    def set_hc
      self.handicap = self.round.handicap(self.score)
    end
    
    # Calculate the class and assign it 
    def set_class
      self.classification = self.category.classification(self.handicap, self.round.indoor, self.record_status)
    end
    
    # Check the score is possible
    def score_possible?
      return if score.blank? || round.blank? || hits.blank?
      
      if score > self.round.max_score
        errors.add(:score, "is over the maximum score possible on that round")
      end
      
      if hits > self.round.max_hits
        errors.add(:hits, "is over the maximum hits possible on that round")
      end
      
      if golds > hits
        errors.add(:golds, "cannot be over the number of hits")
      end
      
      if xs > golds
        errors.add(:xs, "cannot be over the number of golds")
      end
      
      gold_value         = (self.round.max_score / self.round.max_hits)
      non_gold_max_value = gold_value - 1
      
      if score > ((golds * gold_value) + ((hits - golds) * non_gold_max_value))
        errors.add(:score, "score is too high for this many hits & golds")
      end
   
      if score < ((golds * gold_value) + (hits - golds))
        errors.add(:score, "score is too low for this many hits & golds")
      end
      
      if self.round.organisation == "Archery GB" && self.round.indoor == false && (hits + score).odd?
        errors.add(:score, "if round is outdoor imperial hits and score must both be odd or both be even")
      end
    end  
  # end of private
end
