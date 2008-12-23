# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def notable_in_place_editor(field_id, options = {})
    function =  "new Ajax.InPlaceEditor("
    function << "'#{field_id}', "
    function << "'#{url_for(options[:url])}'"

    js_options = {}
    js_options['highlightcolor'] = %('#{options[:highlightcolor]}') if options[:highlightcolor]
    js_options['highlightendcolor'] = %('#{options[:highlightendcolor]}') if options[:highlightendcolor]
    js_options['cancelText'] = %('#{options[:cancel_text]}') if options[:cancel_text]
    js_options['okText'] = %('#{options[:save_text]}') if options[:save_text]
    js_options['loadingText'] = %('#{options[:loading_text]}') if options[:loading_text]
    js_options['savingText'] = %('#{options[:saving_text]}') if options[:saving_text]
    js_options['rows'] = options[:rows] if options[:rows]
    js_options['cols'] = options[:cols] if options[:cols]
    js_options['size'] = options[:size] if options[:size]
    js_options['externalControl'] = "'#{options[:external_control]}'" if options[:external_control]
    js_options['loadTextURL'] = "'#{url_for(options[:load_text_url])}'" if options[:load_text_url]        
    js_options['ajaxOptions'] = options[:options] if options[:options]
    js_options['evalScripts'] = options[:script] if options[:script]
    js_options['callback']   = "function(form) { return #{options[:with]} }" if options[:with]
    js_options['clickToEditText'] = %('#{options[:click_to_edit_text]}') if options[:click_to_edit_text]
    function << (', ' + options_for_javascript(js_options)) unless js_options.empty?
    
    function << ')'

    javascript_tag(function)
  end
  
  def highlightcolor(color)
    case color
      when "red"
        "#FF9999"
      when "blue"
        "#99FFFF"
      when "green"  
        "#99FF99"
      when "yellow"
        "#FFFF99"
    end    
  end
  
  def highlightendcolor(color)
    case color
      when "red"
        "#FFCCCC"
      when "blue"
        "#CCFFFF"
      when "green"  
        "#CCFFCC"
      when "yellow"
        "#FFFFCC"
    end    
  end  
  
end
