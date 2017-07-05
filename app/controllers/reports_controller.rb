class ReportsController < ApplicationController

  def call_logs #reports/call_logs
    # @caregivers = current_user.caregivers
    @calls = current_user.calls
  end
end
