class MetadataController < ApplicationController
  layout false
  skip_before_action :preload_json, :check_xhr, :redirect_to_login_if_required

  def manifest
    render json: default_manifest.to_json
  end

  def opensearch
    render file: "#{Rails.root}/app/views/metadata/opensearch.xml"
  end

  private

  def default_manifest
    logo = SiteSetting.mobile_logo_url.presence || SiteSetting.logo_small_url.presence || SiteSetting.apple_touch_icon_url.presence

    manifest = {
      name: SiteSetting.title,
      short_name: SiteSetting.title,
      display: 'standalone',
      orientation: 'natural',
      start_url: "#{Discourse.base_uri}/",
      background_color: "##{ColorScheme.hex_for_name('secondary')}",
      theme_color: "##{ColorScheme.hex_for_name('header_background')}",
      icons: [
        {
          src: logo,
          sizes: "512x512",
          type: "image/png"
        }
      ]
    }

    if SiteSetting.native_app_install_banner
      manifest = manifest.merge(
        prefer_related_applications: true,
        related_applications: [
          {
            platform: "play",
            id: "com.discourse"
          }
        ]
      )
    end

    manifest
  end
end
