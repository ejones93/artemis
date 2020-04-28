class Round < ApplicationRecord
  has_many :handicaps
  
  # Returns the number of distances in a round 
  def distances
    round_distances_array = [self.distance_1, self.distance_2, self.distance_3, self.distance_4]
    round_distances_array.compact.uniq.count
  end 
  
  # Returns the distances in a round as text
  def distances_to_text
    round_distances_array = [self.distance_2, self.distance_3, self.distance_4]
    distances_text = "[#{self.distance_1}"  
    round_distances_array.compact.uniq.each do |distance|
      distances_text += ", #{distance}"
    end
    distances_text += "]"
  end
  
  # Returns the number of faces
  def faces
    round_faces_array = [self.face_1, self.face_2, self.face_3, self.face_4]
    round_faces_array.compact.uniq.count
  end
  
  # Returns the faces used in a round as text
  def faces_to_text
    if self.name == "Worcester"
      faces_text = "[16\"]"
    else
      faces_text = "[#{self.face_1}cm"
      if !self.face_2.nil? 
        round_faces_array = [self.face_1, self.face_2, self.face_3, self.face_4]
        round_hash = {self.distance_1 => self.face_1, self.distance_2 => self.face_2 ,self.distance_3 => self.face_3, self.distance_4 => self.face_4}
        round_faces_array.compact.uniq.each do |face_size|
          temp_array = []
          round_hash.each do |distance, face|
            if face == face_size
              temp_array << distance
            end
          end
          if face_size == self.face_1
            faces_text += ": "
          else
            faces_text += " | #{face_size}cm: "
          end
          temp_array.each do |distance|
            faces_text += distance + ", "
          end
          faces_text.delete_suffix!(', ')
        end
      end  
      faces_text += "]"
    end
  end
    
  
  # Return a textual representation of round details
  def details
    end_text = ". Ends of " + self.arrows_per_end.to_s + "."
    distance_1_arrows = self.ends_1 * self.arrows_per_end
    details_text = distance_1_arrows.to_s + " @ " + self.distance_1.to_s 
    if !self.distance_2.nil?
      distance_2_arrows = self.ends_2 * self.arrows_per_end
      details_text += ", " + distance_2_arrows.to_s + " @ " + self.distance_2.to_s 
      if !self.distance_3.nil?
        distance_3_arrows = self.ends_3 * self.arrows_per_end
        details_text += ", " + distance_3_arrows.to_s + " @ " + self.distance_3.to_s
        if !self.distance_4.nil?
          distance_4_arrows = self.ends_4 * self.arrows_per_end
          details_text += ", " + distance_4_arrows.to_s + " @ " + self.distance_4.to_s + end_text
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
    if score.class != Integer || score < 1
      nil
    else
      handicap = self.handicaps.where('score <= ' + score.to_s).limit(1).order('score desc').take
      if handicap.nil?
        nil
      elsif handicap.value > 100
        nil
      else
        handicap.value
      end
    end
  end
end