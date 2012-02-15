require 'test_helper'

class MediaplexHelperTest < ActionView::TestCase
  context '#send_to_phone_mediaplex_code' do
    setup do
      @time = Time.new
      Time.stubs(:new).returns(@time)
    end

    context 'with an apartment community' do
      setup do
        @community = ApartmentCommunity.make
        @mpuid     = "#{@time.to_i};#{@community.id}"
      end

      should 'return the correct iframe' do
        code = send_to_phone_mediaplex_code(@community)

        assert_match /Apartments_Send_to_Phone/, code
        assert_match /#{@mpuid}/, code
      end
    end

    context 'with a home community' do
      setup do
        @community = HomeCommunity.make
        @mpuid     = "#{@time.to_i};#{@community.id}"
      end

      should 'return the correct iframe' do
        code = send_to_phone_mediaplex_code(@community)

        assert_match /Bozzuto_Homes_Send_To_Phone/, code
        assert_match /#{@mpuid}/, code
      end
    end
  end


  context '#send_to_friend_mediaplex_code' do
    setup do
      @email = Faker::Internet.email
      @time  = Time.new

      Time.stubs(:new).returns(@time)
    end

    context 'with an apartment community' do
      setup do
        @community = ApartmentCommunity.make
        @mpuid     = "#{@time.to_i};#{@email};#{@community.id}"
      end

      should 'return the correct iframe' do
        code = send_to_friend_mediaplex_code(@community, @email)

        assert_match /Apartments_Send_to_Friend/, code
        assert_match /#{@mpuid}/, code
      end
    end

    context 'with a home community' do
      setup do
        @community = HomeCommunity.make
        @mpuid     = "#{@time.to_i};#{@email};#{@community.id}"
      end

      should 'return the correct iframe' do
        code = send_to_friend_mediaplex_code(@community, @email)

        assert_match /Bozzuto_Homes_Send_To_Friend/, code
        assert_match /#{@mpuid}/, code
      end
    end
  end


  context '#send_me_updates_mediaplex_code' do
    setup do
      @time = Time.new
      Time.stubs(:new).returns(@time)
    end

    context 'with an email address' do
      setup do
        @email = Faker::Internet.email
        @mpuid = "#{@time.to_i};#{@email}"
      end

      should 'return the correct iframe' do
        code = send_me_updates_mediaplex_code(@email)

        assert_match /Apartments_Send_Me_Updates/, code
        assert_match /mpuid=#{@mpuid}/, code
      end
    end

    context 'without an email address' do
      setup do
        @email = nil
        @mpuid = "#{@time.to_i}"
      end

      should 'return the correct iframe' do
        code = send_me_updates_mediaplex_code(@email)

        assert_match /Apartments_Send_Me_Updates/, code
        assert_match /mpuid=#{@mpuid}/, code
      end
    end
  end


  context '#home_contact_form_mediaplex_code' do
    setup do
      @community = HomeCommunity.make
      @time      = Time.new

      Time.stubs(:new).returns(@time)
    end

    context 'with an email address' do
      setup do
        @email = Faker::Internet.email
        @mpuid = "#{@time.to_i};#{@email};#{@community.id}"
      end

      should 'return the correct iframe' do
        code = home_contact_form_mediaplex_code(@community, @email)

        assert_match /Bozzuto_Homes_Lead/, code
        assert_match /mpuid=#{@mpuid}/, code
      end
    end

    context 'without an email address' do
      setup do
        @email = nil
        @mpuid = "#{@time.to_i};#{@community.id}"
      end

      should 'return the correct iframe' do
        code = home_contact_form_mediaplex_code(@community, @email)

        assert_match /Bozzuto_Homes_Lead/, code
        assert_match /mpuid=#{@mpuid}/, code
      end
    end
  end


  context '#bozzuto_buzz_mediaplex_code' do
    setup do
      @time  = Time.new
      @email = Faker::Internet.email
      @mpuid = "#{@time.to_i};#{@email}"

      Time.stubs(:new).returns(@time)
    end

    should 'return the correct iframe' do
      code = bozzuto_buzz_mediaplex_code(@email)

      assert_match /BozzutoBuzz/, code
      assert_match /mpuid=#{@mpuid}/, code
    end
  end


  context '#lead_2_lease_mediaplex_code' do
    setup do
      @email     = Faker::Internet.email
      @community = ApartmentCommunity.make :lead_2_lease_id  => rand
      @mpuid     = "#{@email};#{@community.lead_2_lease_id}"
    end

    should 'return the correct iframe' do
      code = lead_2_lease_mediaplex_code(@community, @email)

      assert_match /Bozzuto\.com_Apartments_Lead/, code
      assert_match /mpuid=#{@mpuid}/, code
    end
  end


  context '#contact_mediaplex_code' do
    setup do
      @time  = Time.new
      @email = Faker::Internet.email
      @mpuid = "#{@time.to_i};#{@email}"

      Time.stubs(:new).returns(@time)
    end

    should 'return the correct iframe' do
      code = contact_mediaplex_code(@email)

      assert_match /Contact_Us/, code
      assert_match /mpuid=#{@mpuid}/, code
    end
  end


  context '#apartment_contact_mediaplex_code' do
    setup do
      @community = ApartmentCommunity.make
      @time      = Time.new
      @email     = Faker::Internet.email
      @mpuid     = "#{@time.to_i};#{@email}"

      Time.stubs(:new).returns(@time)
    end

    context 'community does not have a mediaplex tag' do
      should 'return nil' do
        assert_nil apartment_contact_mediaplex_code(@community, @email)
      end
    end

    context 'community has a mediaplex tag' do
      setup do
        @tag = MediaplexTag.create({
          :page_name => 'batman',
          :roi_name  => 'Batman',
          :trackable => @community
        })
      end

      should 'return the correct iframe' do
        code = apartment_contact_mediaplex_code(@community, @email)

        assert_match /page_name=#{@tag.page_name}/, code
        assert_match /#{@tag.roi_name}=1/, code
        assert_match /mpuid=#{@mpuid}/, code
      end
    end
  end
end
