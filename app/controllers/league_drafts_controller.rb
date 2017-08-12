class LeagueDraftsController < ApplicationController
  before_action :find_league
  def create
    if !@league.league_draft
      Delayed::Job.enqueue DraftMonitorJob.new(@league.create_league_draft.id)
      flash[:success] = "Draft started."
    else
      flash[:notice] = "you have already started a draft."
    end
    redirect
  end

  def destroy
    LeagueDraft.find(params[:id]).destroy
    flash[:success] = "Draft ended."
    redirect
  end

  def redirect
    redirect_to league_path(@league)
  end

  def find_league
    @league = League.find(params[:league_id])
  end
end
