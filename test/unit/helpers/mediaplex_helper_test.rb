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
        @mediaplex_id = "#{@time.to_i};#{@community.id}"
      end

      should 'return the correct iframe' do
        code = send_to_phone_mediaplex_code(@community)

        assert_match /Apartments_Send_to_Phone/, code
        assert_match /#{@mediaplex_id}/, code
      end
    end

    context 'with a home community' do
      setup do
        @community = HomeCommunity.make
        @mediaplex_id = "#{@time.to_i};#{@community.id}"
      end

      should 'return the correct iframe' do
        code = send_to_phone_mediaplex_code(@community)

        assert_match /Bozzuto_Homes_Send_To_Phone/, code
        assert_match /#{@mediaplex_id}/, code
      end
    end
  end


  context '#send_to_friend_mediaplex_code' do
    setup do
      @email        = Faker::Internet.email
      @time         = Time.new
      @mediaplex_id = "#{@time.to_i};#{@email}"

      Time.stubs(:new).returns(@time)
    end

    context 'with an apartment community' do
      setup { @community = ApartmentCommunity.make }

      should 'return the correct iframe' do
        code = send_to_friend_mediaplex_code(@community, @email)

        assert_match /Apartments_Send_to_Friend/, code
        assert_match /#{@mediaplex_id}/, code
      end
    end

    context 'with a home community' do
      setup { @community = HomeCommunity.make }

      should 'return the correct iframe' do
        code = send_to_friend_mediaplex_code(@community, @email)

        assert_match /Bozzuto_Homes_Send_To_Friend/, code
        assert_match /#{@mediaplex_id}/, code
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
        @email        = Faker::Internet.email
        @mediaplex_id = "#{@time.to_i};#{@email}"
      end

      should 'return the correct iframe' do
        code = send_me_updates_mediaplex_code(@email)

        assert_match /Apartments_Send_Me_Updates/, code
        assert_match /mpuid=#{@mediaplex_id}/, code
      end
    end

    context 'without an email address' do
      setup do
        @email        = nil
        @mediaplex_id = "#{@time.to_i}"
      end

      should 'return the correct iframe' do
        code = send_me_updates_mediaplex_code(@email)

        assert_match /Apartments_Send_Me_Updates/, code
        assert_match /mpuid=#{@mediaplex_id}/, code
      end
    end
  end


  context '#home_contact_form_mediaplex_code' do
    setup do
      @community = HomeCommunity.make
      @time = Time.new
      Time.stubs(:new).returns(@time)
    end

    context 'with an email address' do
      setup do
        @email        = Faker::Internet.email
        @mediaplex_id = "#{@time.to_i};#{@email};#{@community.id}"
      end

      should 'return the correct iframe' do
        code = home_contact_form_mediaplex_code(@community, @email)

        assert_match /Bozzuto_Homes_Lead/, code
        assert_match /mpuid=#{@mediaplex_id}/, code
      end
    end

    context 'without an email address' do
      setup do
        @email        = nil
        @mediaplex_id = "#{@time.to_i};#{@community.id}"
      end

      should 'return the correct iframe' do
        code = home_contact_form_mediaplex_code(@community, @email)

        assert_match /Bozzuto_Homes_Lead/, code
        assert_match /mpuid=#{@mediaplex_id}/, code
      end
    end
  end


  context '#bozzuto_buzz_mediaplex_code' do
    setup do
      @time = Time.new
      @email = Faker::Internet.email
      @mediaplex_id = "#{@time.to_i};#{@email}"

      Time.stubs(:new).returns(@time)
    end

    should 'return the correct iframe' do
      code = bozzuto_buzz_mediaplex_code(@email)

      assert_match /BozzutoBuzz/, code
      assert_match /mpuid=#{@mediaplex_id}/, code
    end
  end
end
