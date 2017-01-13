RSpec.describe 'Version' do
  describe '#initialize' do
    it 'is initialized correctly' do
      expect { Version.new('1.2') }.not_to raise_error
      expect { Version.new('1.2.0') }.not_to raise_error
      expect { Version.new('') }.not_to raise_error
      expect { Version.new }.not_to raise_error
      expect { Version.new('0') }.not_to raise_error
      expect { Version.new(Version.new('0')) }.not_to raise_error
    end
    it 'is rising correct errors' do
      expect { Version.new('.2') }
              .to raise_error(ArgumentError, "Invalid version string '.2'")
      expect { Version.new('..2') }
              .to raise_error(ArgumentError, "Invalid version string '..2'")
      expect { Version.new('.0.2') }
              .to raise_error(ArgumentError, "Invalid version string '.0.2'")
      expect { Version.new('0..2.') }
              .to raise_error(ArgumentError, "Invalid version string '0..2.'")
      expect { Version.new('.2.') }
              .to raise_error(ArgumentError, "Invalid version string '.2.'")
      expect { Version.new(' ') }
              .to raise_error(ArgumentError, "Invalid version string ' '")
    end
  end

  describe '#compare' do
    it 'can properly check for equal' do
      expect(Version.new('1.0') == Version.new('1.0.0')).to be true
      expect(Version.new('1') == Version.new('1.0')).to be true
      expect(Version.new('1') == Version.new('1.0.0')).to be true
    end
    it 'can properly check for greater than' do
      expect(Version.new('1.0') > Version.new('0.1.0')).to be true
      expect(Version.new('1.1.0') > Version.new('1.0.1')).to be true
      expect(Version.new('0.0.1') > Version.new('0')).to be true
    end
    it 'can properly check for lower than' do
      expect(Version.new('1.0') < Version.new('1.1.0')).to be true
      expect(Version.new('1.0.1') < Version.new('1.1')).to be true
      expect(Version.new('0') < Version.new('0.0.1')).to be true
    end
    it 'can properly check for greater and eq than' do
      expect(Version.new('1.0') >= Version.new('0.1.0')).to be true
      expect(Version.new('1.1.0') >= Version.new('1.0.1')).to be true
      expect(Version.new('0.0.1') >= Version.new('0')).to be true
    end
    it 'can properly check for lower and eq than' do
      expect(Version.new('1.0') <= Version.new('0.1.0')).not_to be true
      expect(Version.new('1.1.0') <= Version.new('1.1')).to be true
      expect(Version.new('0.0.1') <= Version.new('0.1.0')).to be true
    end
    it 'can properly check for <=>' do
      expect(Version.new('1.0') <=> Version.new('0.1.0')).to eq 1
      expect(Version.new('1.1.0') <=> Version.new('1.1.1')).to eq -1
      expect(Version.new('0.1') <=> Version.new('0.1.0')).to eq 0
    end
  end

  describe '#to_s' do
    it 'can properly convert to string' do
      expect(Version.new('1.3.0').to_s).to eq "1.3"
      expect(Version.new('1.0').to_s).to eq "1"
      expect(Version.new('0.3').to_s).to eq "0.3"
    end
    it 'can properly convert to string with wrong output' do
      expect(Version.new('1.3.0').to_s).not_to eq "1.3.0"
      expect(Version.new('1.3.0').to_s).not_to eq "1.3."
      expect(Version.new('1.0.0').to_s).not_to eq "1.0.0"
      expect(Version.new('1.0.0').to_s).not_to eq "1.0."
    end
  end

  describe '#components' do
    it 'can correctly determine components' do
      expect(Version.new('1.3.0').components).to eq [1, 3]
      expect(Version.new('1.0.0').components).to eq [1]
      expect(Version.new('0.3').components).to eq [0, 3]
    end
    it 'does not change the inner structure' do
      ver = Version.new('1.2.3.4')
      stringified = ver.to_s
      ver.components(2)
      expect(stringified == ver.to_s).to be true
    end
    it 'uses optional argument to retrieve number of components' do
      expect(Version.new('1.3.0').components(3)).to eq [1, 3, 0]
      expect(Version.new('1.3.0').components(2)).to eq [1, 3]
      expect(Version.new('1.3.0').components(1)).to eq [1]
      expect(Version.new('1.3.0').components(5)).to eq [1, 3, 0, 0, 0]
    end
  end
  describe 'Version::Range' do
    describe '#include?' do
      it 'can check if a version is included in a range' do
        range = Version::Range.new(Version.new('1'), Version.new('2'))
        expect(range.include?(Version.new('1.5'))).to be true
      end
    end
    describe '#to_a' do
      it 'can perform to_a properly up to 9' do
        range = Version::Range.new(Version.new('1.1'), Version.new('1.2'))
        result = [
          '1.1', '1.1.1', '1.1.2', '1.1.3', '1.1.4', '1.1.5', '1.1.6',
          '1.1.7', '1.1.8', '1.1.9'
        ]
        expect(range.to_a).to eq result
      end
      it 'can perform to_a properly up to 9' do
        range = Version::Range.new(Version.new('0'), Version.new('0.1'))
        result = [
          '0', '0.0.1', '0.0.2', '0.0.3', '0.0.4', '0.0.5', '0.0.6',
          '0.0.7', '0.0.8', '0.0.9'
        ]
        expect(range.to_a).to eq result
      end
    end
  end
end
