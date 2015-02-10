class ArticlesController < ApplicationController
  require 'will_paginate'
  before_action :set_article, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource
  # GET /articles
  # GET /articles.json
  def find
    @articles = Article.current_due_date
  end
  
  
  def index

    @articles = Article.order(:name)
    @articles = Article.con_nombre_barcode(params[:q]) if params[:q].present?
    @articles = Article.con_id(params[:article_id]) if params[:article_id].present?
    @articles = @articles.paginate(page: params[:page], per_page: 20)
  end

  # GET /articles/1
  # GET /articles/1.json
  def show


  end

  # GET /articles/new
  def new
    @article = Article.new
#    1.times {@article.deadlines.new} 
  end

  # GET /articles/1/edit
  def edit
  end

  # POST /articles
  # POST /articles.json
  def create
    @article = Article.new(article_params)

    respond_to do |format|
      if @article.save
        format.html { redirect_to @article, notice: 'Article was successfully created.' }
        format.json { render :show, status: :created, location: @article }
      else
        format.html { render :new }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /articles/1
  # PATCH/PUT /articles/1.json
  def update
    respond_to do |format|
      if @article.update(article_params)
        format.html { redirect_to articles_path, notice: 'Article was successfully updated.' }
        format.json { render :show, status: :ok, location: @article }
      else
        format.html { render :edit }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /articles/1
  # DELETE /articles/1.json
  def destroy
    @article.destroy
    respond_to do |format|
      format.html { redirect_to articles_url, notice: 'Article was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_article
    @article = Article.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def article_params
    params.require(:article).permit(:name, :price_cost, :percentaje, :price_total, :quantity, :barcode, :supplier_id, :category_id, :due_date, deadlines_attributes:[:id, :article_id, :due_date])
  end
end
