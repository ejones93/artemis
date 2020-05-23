class User < ApplicationRecord
  has_many :scores
  has_many :microposts, dependent: :destroy
  has_many :active_relationships,   class_name:   "Relationship",
                                    foreign_key:  "follower_id",
                                    dependent:    :destroy
  has_many :passive_relationships,  class_name:   "Relationship",
                                    foreign_key:  "followed_id",
                                    dependent:    :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  attr_accessor :remember_token, :activation_token, :reset_token
  before_save { email.downcase! }
  before_create :create_activation_digest
  validates :name,          presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email,         presence: true, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX }, uniqueness: true
  has_secure_password
  validates :password,      presence: true, length: { minimum: 6 }, allow_nil: true
  validates :date_of_birth, presence: true
  validate :valid_dob?
  validate :valid_gender?
  validate :valid_bowtype?
  
  # Returns the hash digest of a given string.
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
  
  # Returns a random token.
  def User.new_token
    SecureRandom.urlsafe_base64
  end
  
  # Remembersa user in the database for use in persistent sessions.
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end
  
  # Returns true if the given token matches the digest.
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end
  
  # Forgets a user
  def forget
    update_attribute(:remember_digest, nil)
  end
  
  # Activates an account.
  def activate
    update_columns(activated: true, activated_at: Time.zone.now)
  end
  
  # Sends activation email.
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end
  
  # Sets the password reset attributes.
  def create_reset_digest
    self.reset_token = User.new_token
    update_columns(reset_digest: User.digest(reset_token), reset_sent_at: Time.zone.now)
  end
  
  # Sends password reset email.
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end
  
  # Returns true if a password reset has expired.
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end
  
  # Defines a proto-feed
  def feed
    following_ids = "Select followed_id FROM relationships 
                    WHERE follower_id = :user_id"
    Micropost.where("user_id IN (#{following_ids}) 
                     OR user_id = :user_id", user_id: id)
  end
  
  # Follows a user.
  def follow(other_user)
    following << other_user
  end
  
  # Unfollows a user.
  def unfollow(other_user)
    following.delete(other_user)
  end
  
  # Returns true if the current user is following the other user.
  def following?(other_user)
    following.include?(other_user)
  end
  
  # Returns the category id for a user based on their age, gender and bowtype
  def find_category(bowtype, date)
    age = ((date.to_time - date_of_birth.to_time) / 1.year.seconds).floor
    case
      when age < 12
        age_group = 11
      when age < 14
        age_group = 13
      when age < 16
        age_group = 15
      when age < 18
        age_group = 17
      when age >= 18
        age_group = 19
      else
        "Error: date of (#{date}) gives invalid age (#{age})"
    end
    Category.where(Gender: gender.first, age: age_group, bowtype: bowtype).take.id
  end
  
  # Gets scores from an outdoor season (defaults to this year)
  def outdoor_season(year = Date.today.year)
    start_date = year.to_s + "-01-01"
    end_date = year.to_s + "-12-31"
    Score.where(user_id: id, indoor: false).where("date BETWEEN '#{start_date}' AND '#{end_date}'")
  end
  
  # Gets scores from an indoor season (defaults to this year)
  def indoor_season(year = Date.today.year)
    if Date.today.month > 7
      start_date = year.to_s + "-07-01"
      end_date = (year + 1).to_s + "-06-30"
    else
      start_date = (year - 1).to_s + "-07-01"
      end_date = year.to_s + "-06-30"
    end
    Score.where(user_id: id, indoor: true).where("date BETWEEN '#{start_date}' AND '#{end_date}'")
  end
  
  # Find a users current handicaps and classifications
  def update_user_stats(bowtype, indoor)
    # Set bowtype categories
    case bowtype
      when "Barebow"
        bowtypes = Array(1..10)
      when "Compound"
        bowtypes = Array(11..20)
      when "Longbow"
        bowtypes = Array(21..30)
      when "Recurve"
        bowtypes = Array(31..40)
    end
    # Check previous years scores and get classifications for last year and this year
    case indoor
      when false
        top_scores = self.outdoor_season(Date.today.year-1).where("category_id IN (#{bowtypes.join(', ')})").reorder(handicap: :asc).limit(3).map(&:handicap)
        classifications = self.outdoor_season(Date.today.year-1).where("category_id IN (#{bowtypes.join(', ')})").map(&:classification)
        last_year_class = check_classification(classifications)
        classifications = self.outdoor_season.where("category_id IN (#{bowtypes.join(', ')})").map(&:classification)
        this_year_class = check_classification(classifications)
        handicaps = self.outdoor_season.where("category_id IN (#{bowtypes.join(', ')})").reorder(date: :asc).map(&:handicap)
      when true
        top_scores = self.indoor_season(Date.today.year-1).where("category_id IN (#{bowtypes.join(', ')})").reorder(handicap: :asc).limit(3).map(&:handicap)
        classifications = self.indoor_season(Date.today.year-1).where("category_id IN (#{bowtypes.join(', ')})").map(&:classification)
        last_year_class = check_classification(classifications)
        classifications = self.indoor_season.where("category_id IN (#{bowtypes.join(', ')})").map(&:classification)
        this_year_class = check_classification(classifications)
        handicaps = self.indoor_season.where("category_id IN (#{bowtypes.join(', ')})").reorder(date: :asc).map(&:handicap)
    end
    # Check if last years classification is better than this years
    if last_year_class[1] < this_year_class[1]
      new_class = last_year_class[0]
    else
      new_class = this_year_class[0]
    end
    # If previous year has > 3 scores use those and update with each new score this year.
    if top_scores.compact.length != 3
      case indoor
        when false
          top_scores = self.outdoor_season.where("category_id IN (#{bowtypes.join(', ')})").reorder(date: :asc).limit(3).map(&:handicap)
        when true
          top_scores = self.indoor_season.where("category_id IN (#{bowtypes.join(', ')})").reorder(date: :asc).limit(3).map(&:handicap)
      end
    end
    if top_scores.compact.length == 3
      avg_hc = top_scores.sum / 3
      handicaps.shift(3)
    end
    if avg_hc
      case indoor
        when false
          case bowtype
            when "Barebow"
              self.outdoor_barebow_hc = check_handicap(handicaps, avg_hc)
              self.outdoor_barebow_class = new_class
            when "Compound"
              self.outdoor_compound_hc = check_handicap(handicaps, avg_hc)
              self.outdoor_compound_class = new_class
            when "Longbow"
              self.outdoor_longbow_hc = check_handicap(handicaps, avg_hc)
              self.outdoor_longbow_class = new_class
            when "Recurve"
              self.outdoor_recurve_hc = check_handicap(handicaps, avg_hc)
              self.outdoor_recurve_class = new_class
          end
        when true
          case bowtype
            when "Barebow"
              self.indoor_barebow_hc = check_handicap(handicaps, avg_hc)
              self.indoor_barebow_class = new_class
            when "Compound"
              self.indoor_compound_hc = check_handicap(handicaps, avg_hc)
              self.indoor_compound_class = new_class
            when "Longbow"
              self.indoor_longbow_hc = check_handicap(handicaps, avg_hc)
              self.indoor_longbow_class = new_class
            when "Recurve"
              self.indoor_recruve_hc = check_handicap(handicaps, avg_hc)
              self.indoor_recurve_class = new_class
          end
      end
    end
    self.save
  end
  
  def update_all_bowtypes
    bowtypes = ["Barebow", "Compound", "Longbow", "Recurve"]
    bowtypes.each do |bowtype|
      self.update_user_stats(bowtype, true)
      self.update_user_stats(bowtype, false)
    end
  end
  private
    # Converts email to all lower-case.
    def downcase_email
      self.email = email.downcase
    end
  
    # Creates and assigns the activation token and digest.
    def create_activation_digest
      self.activation_token  = User.new_token
      self.activation_digest = User.digest(activation_token)
    end
    
    # Check date of birth is between 1900 and the current date
    def valid_dob?
      return if date_of_birth.blank?
      
      unless date_of_birth > Date.parse("1900-01-01")
        errors.add(:date_of_birth, "please enter a valid date of birth")
      end
      
      unless date_of_birth < Date.today
        errors.add(:date_of_birth, "must be in the past")
      end
    end    

    # Check gender is an expected value
    def valid_gender?
      genders = ["Male", "Female"]
      unless genders.include?(gender)
        errors.add(:gender, "please pick from the options available")
      end
    end
    
    # Check default bowtype is an expected value
    def valid_bowtype?
      bowtypes = ["Barebow", "Compound", "Longbow", "Recurve"]
      unless bowtypes.include?(default_bowtype)
        errors.add(:default_bowtype, "please pick from the options available")
      end
    end
  # End of private.
end
