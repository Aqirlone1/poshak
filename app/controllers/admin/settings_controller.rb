class Admin::SettingsController < Admin::BaseController
  def show
    @settings = Rails.cache.fetch("admin_store_settings") do
      { site_name: "Poshak", support_email: "support@example.com", cod_enabled: true, maintenance_mode: false }
    end
  end

  def update
    settings = Rails.cache.fetch("admin_store_settings") do
      { site_name: "Poshak", support_email: "support@example.com", cod_enabled: true, maintenance_mode: false }
    end
    updated = settings.merge(settings_params.to_h.symbolize_keys)
    Rails.cache.write("admin_store_settings", updated)
    redirect_to admin_settings_path, notice: "Settings updated."
  end

  private

  def settings_params
    params.fetch(:settings, {}).permit(:site_name, :support_email, :cod_enabled, :maintenance_mode)
  end
end
