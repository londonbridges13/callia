class ReportsController < ApplicationController

  def call_logs #reports/call_logs
    # @caregivers = current_user.caregivers
    @calls = current_user.calls.order("created_at DESC")
  end
end
