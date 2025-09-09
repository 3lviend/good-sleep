module Searchable
  extend ActiveSupport::Concern

  included do
    class_attribute :permitted_ransack_params

    self.permitted_ransack_params = []

    helper_method :ransack_params
  end

  def ransack_params
    return {} if params[:q].blank?

    permitted_params = if self.is_a?(ActionController::Base)
      permitted_ransack_params
    elsif self.is_a?(ActionView::Base)
      self.controller&.permitted_ransack_params
    else
      []
    end

    params.require(:q).permit(permitted_params).compact_blank
  end
end
