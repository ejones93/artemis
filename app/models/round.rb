class Round < ApplicationRecord
  has_many :handicaps
  
  # Returns the number of distances in a round 
  def distances
    if !self.distance_4.nil? 
      4
    elsif !self.distance_3.nil?
      3
    elsif !self.distance_2.nil?
      2
    else
      1
    end
  end 
  
  # Returns the distances in a round as text
  def distances_to_text
    if !self.distance_4.nil? 
      distances_text = "[" + distance_1 + ", " + distance_2 + ", " + distance_3 + ", " + distance_4 + "]"
    elsif !self.distance_3.nil?
      distances_text = "[" + distance_1 + ", " + distance_2 + ", " + distance_3 + "]"
    elsif !self.distance_2.nil?
      distances_text = "[" + distance_1 + ", " + distance_2 + "]"
    else
      distances_text = "[" + distance_1 + "]"
    end
  end
  
  # Return a textual representation of round details
  def details
    end_text = ". Ends of " + self.arrows_per_end.to_s + " arrows."
    distance_1_arrows = self.ends_1 * self.arrows_per_end
    details_text = distance_1_arrows.to_s + " arrows at " + self.distance_1.to_s + " on a " + self.face_1.to_s + "cm face"
    if !self.distance_2.nil?
      distance_2_arrows = self.ends_2 * self.arrows_per_end
      details_text += ", then " + distance_2_arrows.to_s + " arrows at " + self.distance_2.to_s + " on a " + self.face_2.to_s + "cm face"
      if !self.distance_3.nil?
        distance_3_arrows = self.ends_3 * self.arrows_per_end
        details_text += ", then " + distance_3_arrows.to_s + " arrows at " + self.distance_3.to_s + " on a " + self.face_3.to_s + "cm face"
        if !self.distance_4.nil?
          distance_4_arrows = self.ends_4 * self.arrows_per_end
          details_text += ", finally " + distance_4_arrows.to_s + " arrows at " + self.distance_4.to_s + " on a " + self.face_4.to_s + "cm face" + end_text
        else
          details_text += end_text
        end
      else
        details_text += end_text
      end
    else
      details_text += end_text
    end
  end
  
  # Returns a handicap value from a round with a score
  def handicap(score)
    handicap = self.handicaps.where('score <= ' + score.to_s).limit(1).order('score desc').take
    if handicap.nil?
      "N/A"
    else
      handicap.value
    end
  end
end