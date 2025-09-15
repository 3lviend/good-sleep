
module UserFindable
  extend ActiveSupport::Concern

  private

  def find_user(user_id = params[:user_id])
    Rails.cache.fetch("User::#{user_id}", expires_in: 10.minutes) do
      User.find(user_id)
    end
  rescue ActiveRecord::RecordNotFound
    raise ActiveRecord::RecordNotFound, "User not found"
  end
end
