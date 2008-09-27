# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def li_for(record, *args, &block)
    content_tag_for(:li, record, *args, &block)
  end
  
  def tr_for(record, *args, &block)
    content_tag_for(:tr, record, *args, &block)
  end
  
  def global_highlight_start
    "#FFDDDD"    
  end
  
  def global_highlight_end
    "#FFFFFF"    
  end
  
  def random_string(length=8)
    chars = ["A".."Z","a".."z","0".."9"].collect { |r| r.to_a }.join #+ %q(!@$%^&*)
    password = (1..length).collect { chars[rand(chars.size)] }.pack("C*")
  end
  
	def yui_css
	  if RAILS_ENV=='production' && false ### NO LONGER PULLING FROM LIVE SITE
	    '<link rel="stylesheet" type="text/css" href="http://yui.yahooapis.com/2.5.0/build/reset-fonts-grids/reset-fonts-grids.css">' 
    else
      stylesheet_link_tag 'yui/reset-fonts-grids'
    end
	end

  def params_to_hidden_fields(params, scope=[], depth=0, options={})
    # Reject parameters you don't want to stay persistent
    reject_list = %w(action controller authenticity_token)
    reject_list = reject_list + options[:reject] if options[:reject]
    params = params.reject{|key, value| reject_list.include?(key)}
    puts reject_list

    #The final output to return
    output = ""

    # Cycle through each object in the hash
    params.each do |key, value|
      # If the value is a Hash, recursively call this function on that Hash
      # otherwise turn it into a hidden field
      output << if value.class == HashWithIndifferentAccess            
        "#{params_to_hidden_fields(value, scope + [key], depth+1, options)}"
      else 
        # This conditional sets the scope for the hidden fields.  Nested objects in 
        # Rails are displayed like this:
        #    <input type="hidden" name="main_object[:subj_object][:key]" id="main_object_subj_object_key" value="value" />
        # so we need keep track of the parent calls
        name = if scope.empty?
          "#{key}"
        else
          scope.first.to_s + scope[1..scope.length].inject(""){|sum, crumb| "#{sum}[#{crumb}]" } + "[#{key}]"
        end
        
        # Basic output
        "<input type=\"hidden\" name=\"#{h name}\" value=\"#{h value}\" />\n"
      end
    end
    output
  end
  
end