class TxtGeneratorService
    def initialize(session,session_attachments,user)
      @session = session
      @session_attachments = session_attachments
      @user = user
    end 

    def call
        
      i = 1

      text = ""
      @session_attachments.each do |s|
        text << ("Picture: " + s[:image] + ". ")
        i += 1 
        session_points = s.points
        j = 1
        session_points.each do |p|
          text << ("\n")
          text << (j.to_s + ": ")
          text << ("x: " + (s.image_width*p.x).round().to_s )
          text << (", y: " + (s.image_height*p.y).round().to_s )
    
          j+=1
          mark = p.marks.where(user_id: @user.id).first
          text << (" Choosen option: " + mark.description )
        end 
        text << ("\n")       
      end
      text
    end 
end 