module EnumI18n
  extend ActiveSupport::Concern

  class_methods do
    def human_enum_name(enum_name, value)
      I18n.t("activerecord.attributes.#{model_name.i18n_key}.#{enum_name}.#{value}", default: value.to_s.humanize)
    end
  end

  private

  def enum_i18n(enum_name)
    value = send(enum_name)
    return "" unless value
    self.class.human_enum_name(enum_name, value)
  end
end
