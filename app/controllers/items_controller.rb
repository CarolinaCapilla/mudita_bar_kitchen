class ItemsController < ApplicationController
  before_action :set_item, only: %i[show edit update destroy]
  # skip_before_action :authenticate_user!, only: %i[show index]

  def show
    if current_user.chef
      @items = Item.where(user: user)
    else
      @items = Item.all
    end
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    @item.user = current_user
    @item.allergen = params['item']['allergen'].join(',')
    if @item.save
      redirect_to @item, notice: "Item successfully created."
    else
      render :new
    end
  end

  def edit; end

  def update
    if @item.update(item_params)
      redirect_to @item, notice: "Item successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @item.destroy
    redirect_to items_path, notice: "Item successfully destroyed."
  end

  private

  def set_item
    @item = Item.find(params[:id])
  end

  def item_params
    params.require(:item).permit(:dish, :description, :category, :price, {:allergen => []}, :ingredient)
  end
end