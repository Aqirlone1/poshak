class Account::AddressesController < Account::BaseController
  before_action :set_address, only: %i[show edit update destroy]

  def index
    @addresses = current_user.addresses.order(is_default: :desc, created_at: :desc)
  end

  def show
  end

  def new
    @address = current_user.addresses.new
  end

  def create
    @address = current_user.addresses.new(address_params)
    if @address.save
      redirect_to account_addresses_path, notice: "Address created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @address.update(address_params)
      redirect_to account_addresses_path, notice: "Address updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @address.destroy
    redirect_to account_addresses_path, notice: "Address deleted."
  end

  private

  def set_address
    @address = current_user.addresses.find(params[:id])
  end

  def address_params
    params.require(:address).permit(:address_type, :full_name, :phone_number, :address_line1, :address_line2, :city, :state,
                                    :postal_code, :country, :is_default)
  end
end
