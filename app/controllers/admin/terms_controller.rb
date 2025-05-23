class Admin::TermsController < ApplicationController
  before_action :authenticate_admin!

  def show
    @term = Term.first
  end

  def edit
    @term = Term.first!
  end

  def update
    @term = Term.first!
    if @term.update(term_params)
      redirect_to admin_term_path, notice: "利用規約を更新しました。"
    else
      flash.now[:alert] = "利用規約の内容を入力してください。"
      render :edit
    end
  end

  private

  def term_params
    params.require(:term).permit(:content)
  end
end
