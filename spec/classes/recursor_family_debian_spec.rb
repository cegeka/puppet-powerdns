require 'spec_helper'

describe 'powerdns::recursor', type: 'class' do

  ['Debian', 'Ubuntu'].each do |distro|

    context "on #{distro} OS" do

      let :facts do
        {
          'operatingsystem' => distro,
          'kernel'          => 'Linux',
          'osfamily'        => 'Debian',
          'lsbdistid'       => 'Debian'
        }
      end

      let(:recursor_package_name) { 'pdns-recursor' }
      let(:config_file_path)      { '/etc/powerdns' }
      let(:recursor_config_file)  { 'recursor.conf' }


      context 'tests with the default parameters' do

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to create_class('powerdns::recursor') }

        it { is_expected.to contain_powerdns__install("#{recursor_package_name}") }
        it { is_expected.to contain_package("#{recursor_package_name}") }

        it { is_expected.to contain_powerdns__config("#{recursor_config_file}") }
        it { is_expected.to create_file("#{config_file_path}/#{recursor_config_file}") }

        it { is_expected.to contain_powerdns__service("#{recursor_package_name}") }
        it { is_expected.to contain_service("#{recursor_package_name}") }

      end # en contex init class

    end # contex distro

  end # do distro

end # powerdns
