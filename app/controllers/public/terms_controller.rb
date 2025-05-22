class Public::TermsController < ApplicationController
  def show
    @term = Term.first
  end
end