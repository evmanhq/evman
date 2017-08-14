module FormsHelper
  def nested_option_groups_from_collection_for_select(collection, group_method, group_label_method, option_key_method, option_value_method, selected_key = nil)
    collection.map do |group|
      if group.send(group_method).any?
        option_tags = options_from_collection_for_select(
            group.send(group_method), option_key_method, option_value_method, selected_key)

        content_tag("optgroup".freeze, option_tags, label: group.send(group_label_method))
      else
        options_from_collection_for_select([group], option_key_method, option_value_method, selected_key)
      end
    end.join.html_safe
  end
end