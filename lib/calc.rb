module Calc
  def calc_followers_per_hour(target_users, reset = false)
    target_users.each do |user|
      if reset
        frames = user.wb_target_user_frames.order("created_at asc")
        frames.each do |frame|
          frame.followers_per_hour = nil
          frame.followers_per_hour_smoothed = nil
        end
      else
        start_frame = user.wb_target_user_frames.order("created_at desc").where("followers_per_hour is not null").first
        frames = user.wb_target_user_frames.order("created_at asc").where("created_at > ?", start_frame ? start_frame.created_at : Time.at(0)).all
        frames.unshift(start_frame) if start_frame
      end

      WbTargetUserFrame.transaction do
        frames[1..-1].each_with_index do |frame, i|
          next if frame.followers_per_hour
          # binding.pry
          calc_followers_per_hour_one_frame(frame, frames[i]) # not i-1
          frame.save!
        end
      end
    end
  end

  def calc_followers_per_hour_one_frame(frame, prev_frame)
    if !prev_frame
      # can't do much here
    else
      # derivative
      frame.followers_per_hour = ((frame.followers_count - prev_frame.followers_count)*1.hour/(frame.created_at.to_f - prev_frame.created_at.to_f)).round(30) # prevent underflow

      # smoothing
      alpha = 0.1

      if prev_frame.followers_per_hour_smoothed
        # easy
        frame.followers_per_hour_smoothed = (alpha*prev_frame.followers_per_hour + (1 - alpha)*prev_frame.followers_per_hour_smoothed).round(30)
      elsif prev_frame.followers_per_hour
        frame.followers_per_hour_smoothed = prev_frame.followers_per_hour
      end
    end
  end

end