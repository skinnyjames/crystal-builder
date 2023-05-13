@[Barista::BelongsTo(CrystalBuilder)]
class Tasks::Cacerts < Barista::Task
  include Common::Task

  @@name = "cacerts"

  VERSION = "2022.07.19"

  file("license_patch", "#{__DIR__}/../patches/cacerts/add-license-file.patch")

  def build : Nil
    patch(file("license_patch"), string: true)
    mkdir(cert_dir, parents: true)

    block do
      Crest.get(source_url) do |res|
        File.open("#{cert_dir}/cacert.pem", "w") do |f|
          str = res.body_io.gets_to_end
          f << str
          f << versign_certs unless str.includes?("Verisign Class 3 Public Primary Certification Authority")
        end
      end
    end

    link("certs/cacert.pem", "cert.pem", chdir: "#{smart_install_dir}/embedded/ssl")
    command("chmod 644 #{smart_install_dir}/embedded/ssl/certs/cacert.pem")
  end

  def configure : Nil
    version(display_version)
    license("MPL-2.0")
  end

  def cert_dir
    File.join(smart_install_dir, "embedded", "ssl", "certs")
  end

  def source_url
    "https://curl.haxx.se/ca/cacert-#{url_version}.pem"
  end

  def url_version
    VERSION.gsub(".", "-")
  end

  def display_version
    VERSION.tr(".", "")
  end

  def versign_certs
    <<-EOH
    Verisign Class 3 Public Primary Certification Authority
    =======================================================
    -----BEGIN CERTIFICATE-----
    MIICPDCCAaUCEHC65B0Q2Sk0tjjKewPMur8wDQYJKoZIhvcNAQECBQAwXzELMAkGA1UEBhMCVVMx
    FzAVBgNVBAoTDlZlcmlTaWduLCBJbmMuMTcwNQYDVQQLEy5DbGFzcyAzIFB1YmxpYyBQcmltYXJ5
    IENlcnRpZmljYXRpb24gQXV0aG9yaXR5MB4XDTk2MDEyOTAwMDAwMFoXDTI4MDgwMTIzNTk1OVow
    XzELMAkGA1UEBhMCVVMxFzAVBgNVBAoTDlZlcmlTaWduLCBJbmMuMTcwNQYDVQQLEy5DbGFzcyAz
    IFB1YmxpYyBQcmltYXJ5IENlcnRpZmljYXRpb24gQXV0aG9yaXR5MIGfMA0GCSqGSIb3DQEBAQUA
    A4GNADCBiQKBgQDJXFme8huKARS0EN8EQNvjV69qRUCPhAwL0TPZ2RHP7gJYHyX3KqhEBarsAx94
    f56TuZoAqiN91qyFomNFx3InzPRMxnVx0jnvT0Lwdd8KkMaOIG+YD/isI19wKTakyYbnsZogy1Ol
    hec9vn2a/iRFM9x2Fe0PonFkTGUugWhFpwIDAQABMA0GCSqGSIb3DQEBAgUAA4GBALtMEivPLCYA
    TxQT3ab7/AoRhIzzKBxnki98tsX63/Dolbwdj2wsqFHMc9ikwFPwTtYmwHYBV4GSXiHx0bH/59Ah
    WM1pF+NEHJwZRDmJXNycAA9WjQKZ7aKQRUzkuxCkPfAyAw7xzvjoyVGM5mKf5p/AfbdynMk2Omuf
    Tqj/ZA1k
    -----END CERTIFICATE-----

    Verisign Class 3 Public Primary Certification Authority
    =======================================================
    -----BEGIN CERTIFICATE-----
    MIICPDCCAaUCEDyRMcsf9tAbDpq40ES/Er4wDQYJKoZIhvcNAQEFBQAwXzELMAkGA1UEBhMCVVMx
    FzAVBgNVBAoTDlZlcmlTaWduLCBJbmMuMTcwNQYDVQQLEy5DbGFzcyAzIFB1YmxpYyBQcmltYXJ5
    IENlcnRpZmljYXRpb24gQXV0aG9yaXR5MB4XDTk2MDEyOTAwMDAwMFoXDTI4MDgwMjIzNTk1OVow
    XzELMAkGA1UEBhMCVVMxFzAVBgNVBAoTDlZlcmlTaWduLCBJbmMuMTcwNQYDVQQLEy5DbGFzcyAz
    IFB1YmxpYyBQcmltYXJ5IENlcnRpZmljYXRpb24gQXV0aG9yaXR5MIGfMA0GCSqGSIb3DQEBAQUA
    A4GNADCBiQKBgQDJXFme8huKARS0EN8EQNvjV69qRUCPhAwL0TPZ2RHP7gJYHyX3KqhEBarsAx94
    f56TuZoAqiN91qyFomNFx3InzPRMxnVx0jnvT0Lwdd8KkMaOIG+YD/isI19wKTakyYbnsZogy1Ol
    hec9vn2a/iRFM9x2Fe0PonFkTGUugWhFpwIDAQABMA0GCSqGSIb3DQEBBQUAA4GBABByUqkFFBky
    CEHwxWsKzH4PIRnN5GfcX6kb5sroc50i2JhucwNhkcV8sEVAbkSdjbCxlnRhLQ2pRdKkkirWmnWX
    bj9T/UWZYB2oK0z5XqcJ2HUw19JlYD1n1khVdWk/kfVIC0dpImmClr7JyDiGSnoscxlIaU5rfGW/
    D/xwzoiQ
    -----END CERTIFICATE-----
    EOH
  end
end
