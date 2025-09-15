# frozen_string_literal: true

def cleanup_with_truncate
  after do
    ActiveRecord::Tasks::DatabaseTasks.truncate_all(:test)
  end
end
