module NearInfinityWebsite
  class VideoTag < Liquid::Tag

    def initialize(tag_name, text, tokens)
      super
      @text = text
    end

    def render(context)
      match = @text.match /^\s*:(\w+)\s*=>\s*(\w+)\s*$/
      help_text = "video_tag syntax is :[vimeo|youtube] => [video_id]" 

      return help_text unless match and match.size == 3
      
      type = match[1].to_sym
      return help_text unless [:vimeo, :youtube].include? type

      video_id = match[2]

      case type
      when :vimeo
        "<div class=video><iframe src='//player.vimeo.com/video/#{video_id}?color=ff9933' frameborder=0></iframe></div>"
      when :youtube
        "<div class=video><iframe src='//www.youtube.com/embed/#{video_id}?autohide=1&controls=1&showinfo=0' frameborder=0 allowfullscreen></iframe></div>"
      else
        help_text
      end
    end
  end
end


Liquid::Template.register_tag('video_tag', NearInfinityWebsite::VideoTag)
