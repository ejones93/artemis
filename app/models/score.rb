class Score < ApplicationRecord
  belongs_to :user
  belongs_to :round
  belongs_to :category
  after_initialize :init
  validates :user_id, presence: true
  validates :round_id, presence: true
  validates :category_id, presence: true
  validates :score, presence: true
  validates :hits, presence: true
  validates :location, presence: true
  validates :date, presence: true
  validate :date_after_today
  validate :score_possible
  
  def init
    self.golds  ||= 0
    self.xs     ||= 0
  end
  
  private
  
  def date_after_today
    return if date.blank?
    
    if date > Date.today
      errors.add(:date, "cannot be in the future")
    end
  end
  
  def score_possible
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
end
