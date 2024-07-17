require "rails_helper"

RSpec.describe "Songs for an Artist Endpoings" do
  before :each do
    @prince = Artist.create!(name: "Prince")
    @prince.songs.create!(title: "Raspberry Beret", length: 345, play_count: 34)
    @prince.songs.create!(title: "Purple Rain", length: 524, play_count: 19)
    @prince.songs.create!(title: "Kiss", length: 575, play_count: 89)

    other_artist = Artist.create!(name: "Beyonce")
    @other_song = other_artist.songs.create!(title: "Halo", length: 678, play_count: 77)
  end

  it "can return all songs for a given artist" do
    get "/api/v1/artists/#{@prince.id}/songs"

    expect(response).to be_successful

    songs = JSON.parse(response.body, symbolize_names: true)

    expect(songs.count).to eq(3)

    songs.each do |song|
      expect(song[:id]).to_not eq(@other_song.id)
    end
  end

  it "can create a new song for a given artist" do
    song_params = ({
      title: "When Doves Cry",
      length: 4567,
      play_count: 456445
    })

    post "/api/v1/artists/#{@prince.id}/songs", params: song_params, as: :json
    created_song = Song.last

    expect(response).to be_successful
    expect(response.code).to eq("201")

    expect(created_song.title).to eq(song_params[:title])
    expect(created_song.length).to eq(song_params[:length])
    expect(created_song.play_count).to eq(song_params[:play_count])
    expect(created_song.artist).to eq(@prince)
  end

end