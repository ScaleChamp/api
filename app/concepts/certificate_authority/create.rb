class CertificateAuthority::Create < ServiceObject
  attr_reader :project

  TEN_YEARS = 365 * 24 * 60 * 60 * 10

  def initialize(project)
    @project = project
  end

  def call
    private_key = OpenSSL::PKey::RSA.new(2048)

    values = [
        {O: 'ScaleChamp'},
        {CN: "#{project.id} Project CA"}
    ]

    subject = values.collect { |l| l.collect { |k, v| "/#{k}=#{v}" }.join }.join

    project_ca = OpenSSL::X509::Certificate.new
    project_ca.subject = project_ca.issuer = OpenSSL::X509::Name.parse(subject)
    project_ca.not_before = Time.now
    project_ca.not_after = project_ca.not_before + TEN_YEARS
    project_ca.serial = project_ca.not_before.to_i
    project_ca.public_key = private_key.public_key
    project_ca.version = 2

    ef = OpenSSL::X509::ExtensionFactory.new
    ef.subject_certificate = project_ca
    ef.issuer_certificate = project_ca

    project_ca.extensions = [
        ef.create_extension("basicConstraints", "CA:TRUE", true),
        ef.create_extension("subjectKeyIdentifier", "hash"),
        ef.create_extension("keyUsage", "cRLSign,keyCertSign", true),
    ]

    project_ca.add_extension ef.create_extension("authorityKeyIdentifier", "keyid:always,issuer:always")

    project_ca.sign(private_key, OpenSSL::Digest::SHA256.new)

    project.create_certificate_authority!(key: private_key.to_pem, crt: project_ca.to_pem)
  end
end
