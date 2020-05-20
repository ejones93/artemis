class Category < ApplicationRecord
  has_many :scores
  
  def classification(handicap, indoor, rs = "none")
    if handicap.nil?
      nil
    else
      if indoor
        case
          when handicap <= a_hc
            "A"
          when handicap <= b_hc
            "B"
          when handicap <= c_hc
            "C"
          when handicap <= d_hc
            "D"
          when handicap <= e_hc
            "E"
          when handicap <= f_hc
            "F"
          when handicap <= g_hc
            "G"
          when handicap <= h_hc
            "H"
        end
      else
        case 
          when handicap <= gmb_hc && ( rs == "ukrs" || rs == "wrs" )
            "Grand Master Bowman"
          when handicap <= mb_hc && ( rs == "ukrs" || rs == "wrs" )
            "Master Bowman"
          when handicap <= bowman_hc
            "Bowman"
          when handicap <= first_hc
            "1st Class"
          when handicap <= second_hc
            "2nd Class"
          when handicap <= third_hc
            "3rd Class"
        end
      end
    end
  end
end
