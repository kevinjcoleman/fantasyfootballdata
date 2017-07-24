class PagesController < ApplicationController
  def home
    @teams = NflTeam.all
  end
end
