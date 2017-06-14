# SoTube
A music store for iOS

## Scope of the project:
Build a store (named SoTube) with the following functionalities:
- the user can login to a personal account
- each account contains points which can be bought with real money (the last part doesn’t need to be implemented)
- there should be an overview of all purchases
- once logged in, a user can buy songs with points
- user needs to confirm purchase before continuing
- once a song is bought, a user can play the full song
- bought songs need to be in a personal database
- when a user is not logged in (or didn’t yet buy the song), only a preview of the song is available (e.g. 30 sec)
- songs can come from a server, SoundCloud, Spotify,… and accessed through their API
- the app must run smoothly (async methodes and activity indicators)
- the app must look good and work on every iOS device
- you can choose to support landscape (although desirable)

Possible extras:
- buying points (e.g. with PayPal)
- sharing your purchase with friends (Facebook, Twitter,…)
- possibility to search by name
- possibility to sort

## The app SoTube:
### Loginscreen
<table style="width:100%">
  <tr style="border-top: 0;">
    <td style="border: 0;"><img src="https://github.com/JonathanEsposito/SoTube/blob/master/rmresource/00login.png"></td>
    <td style="border: 0;"><img src="https://github.com/JonathanEsposito/SoTube/blob/master/rmresource/01passwordReset.png"></td> 
    <td style="border: 0;"><img src="https://github.com/JonathanEsposito/SoTube/blob/master/rmresource/02createAccount.png"></td>
  </tr>
</table>

- the user can log in as a registered user or login as guest
- recover its password
- create a new account

 

### Ways to enter the app
<table style="width:100%">
  <tr style="border-top: 0;">
    <td style="border: 0;"><img src="https://github.com/JonathanEsposito/SoTube/blob/master/rmresource/03enteredAsGuest.png"></td>
    <td style="border: 0;"><img src="https://github.com/JonathanEsposito/SoTube/blob/master/rmresource/02loginToStore.png"></td> 
    <td style="border: 0;"><img src="https://github.com/JonathanEsposito/SoTube/blob/master/rmresource/04myMusic.png"></td>
  </tr>
</table>

- When a user logs in as guest, the user is immediatly directed to the store. The tabbar is customised to only show the store, a login button and a create account button.
- When a user logs in as a registered guest and the user has no purchased songs yet, it is directed to the store as well, but with the default tabbar.
- When a user logs in as a registered guest and the user has already bought songs, it is directed to their bought music.

### The store
<table style="width:100%">
  <tr style="border-top: 0;">
    <td style="border: 0;"><img src="https://github.com/JonathanEsposito/SoTube/blob/master/rmresource/02loginToStore.png"></td>
    <td style="border: 0;"><img src="https://github.com/JonathanEsposito/SoTube/blob/master/rmresource/03storeNavigation.png"></td> 
    <td style="border: 0;"><img src="https://github.com/JonathanEsposito/SoTube/blob/master/rmresource/03storePlaylists.png"></td>
  </tr>
</table>

The user can browse through new releases, featured playlist and moods

<table style="width:100%">
  <tr style="border-top: 0;">
    <td style="border: 0;"><img src="https://github.com/JonathanEsposito/SoTube/blob/master/rmresource/03storeSearch00.png"></td>
    <td style="border: 0;"><img src="https://github.com/JonathanEsposito/SoTube/blob/master/rmresource/03storeSearchArtistAlbums.png"></td> 
    <td style="border: 0;"><img src="https://github.com/JonathanEsposito/SoTube/blob/master/rmresource/03storeSearch01.png"></td>
  </tr>
</table>

The user can sumltaniously search for albums, artists, tracks and playlists and can navigate through them

<table style="width:100%">
  <tr style="border-top: 0;">
    <td style="border: 0;"><img src="https://github.com/JonathanEsposito/SoTube/blob/master/rmresource/03storeBuySong.png"></td>
    <td style="border: 0;"><img src="https://github.com/JonathanEsposito/SoTube/blob/master/rmresource/03storeNotEnoughCoins.png"></td> 
    <td style="border: 0;"><img src="https://github.com/JonathanEsposito/SoTube/blob/master/rmresource/03storeTopUp.png"></td>
  </tr>
</table>
In the store, the user can buy a song anywhere it is displayed. In a search result, an album, a playlist,...

- When the user clicks on buy, a confirmation screen is shown. When the user buys the track, the buy option disappears.
- When the user does not have enough coins an alert is shown with the option to top up their account or to cancel.
- When the user choses to top up there account, the get the option to choose the amount of coins and is shown the price.

<table style="width:100%">
  <tr style="border-top: 0;">
    <td style="border: 0;"><img src="https://github.com/JonathanEsposito/SoTube/blob/master/rmresource/03storePaypal00.png"></td>
    <td style="border: 0;"><img src="https://github.com/JonathanEsposito/SoTube/blob/master/rmresource/03storePaypal01.png"></td> 
    <td style="border: 0;"><img src="https://github.com/JonathanEsposito/SoTube/blob/master/rmresource/03storePaypal02.png"></td>
  </tr>
</table>

The user can choose to pay with PayPal. In PayPal, the user can log in to paypal and pay, or choose to use a credit card

### My Music
<table style="width:100%">
  <tr style="border-top: 0;">
    <td style="border: 0;"><img src="https://github.com/JonathanEsposito/SoTube/blob/master/rmresource/04myMusic.png"></td>
    <td style="border: 0;"><img src="https://github.com/JonathanEsposito/SoTube/blob/master/rmresource/05iPhoneShow.png"></td> 
    <td style="border: 0;"><img src="https://github.com/JonathanEsposito/SoTube/blob/master/rmresource/05iPhoneSort.png"></td>
  </tr>
</table>

- by default, the user lands on albums, sorted by artist name but can be sorted by album name.
- the user can choose to view all songs, all albums or all artists of their bought songs.
- all songs can be sorted by name but are by default sorted by artist name>album name>album track number.

<table style="width:100%">
  <tr style="border-top: 0;">
    <td style="border: 0;"><img src="https://github.com/JonathanEsposito/SoTube/blob/master/rmresource/05iPadShow.png"></td>
    <td style="border: 0;"><img src="https://github.com/JonathanEsposito/SoTube/blob/master/rmresource/05iPadSort.png"></td>
  </tr>
</table>

The display and sort menus on an iPad

<table style="width:100%">
  <tr style="border-top: 0;">
    <td style="border: 0;"><img src="https://github.com/JonathanEsposito/SoTube/blob/master/rmresource/05artistSplitview.png"></td>
    <td style="border: 0;"><img src="https://github.com/JonathanEsposito/SoTube/blob/master/rmresource/06albumviewPortret.png"></td> 
    <td style="border: 0;"><img src="https://github.com/JonathanEsposito/SoTube/blob/master/rmresource/06albumviewLandscape.png"></td>
  </tr>
</table>

- The artist view with on the left all artists and on the right all bought albums of the selected artist.
- The album view in portret 
- The album view in landscape

### The Music Player

<table style="width:100%">
  <tr style="border-top: 0;">
    <td style="border: 0;"><img src="https://github.com/JonathanEsposito/SoTube/blob/master/rmresource/miniplayerPortret.png"></td>
    <td style="border: 0;"><img src="https://github.com/JonathanEsposito/SoTube/blob/master/rmresource/miniplayerLandscape.png"></td> 
    <td style="border: 0;"><img src="https://github.com/JonathanEsposito/SoTube/blob/master/rmresource/miniplayerEverywhere.png"></td>
  </tr>
</table>

- If the user taps a track, a miniplayer wil appear right on top of the tabbar at the buttom.
- When in landscape the miniplayer will move into the tabbar to fill the unused space
- The miniplayer will be present everywhere you are in the app. On it, the user can control the pause and play back of the song

<table style="width:100%">
  <tr style="border-top: 0;">
    <td style="border: 0;"><img src="https://github.com/JonathanEsposito/SoTube/blob/master/rmresource/playerPortret.png"></td>
    <td style="border: 0;"><img src="https://github.com/JonathanEsposito/SoTube/blob/master/rmresource/playerLandscape.png"></td>
  </tr>
</table>

When the user taps the miniplayer anywhere but the pause/play button, a bigger player will be shown fullscreen on the iphone.

<table style="width:100%">
  <tr style="border-top: 0;">
    <td style="border: 0;"><img src="https://github.com/JonathanEsposito/SoTube/blob/master/rmresource/playeriPadPortret.png"></td>
    <td style="border: 0;"><img src="https://github.com/JonathanEsposito/SoTube/blob/master/rmresource/playeriPadLandscape.png"></td>
  </tr>
</table>

On the iPad the bigger player will be shown as a popover. (Note that the volume control
is only available on a real device and will not be shown in the simulator)

<table style="width:100%">
  <tr style="border-top: 0;">
    <td style="border: 0;"><img src="https://github.com/JonathanEsposito/SoTube/blob/master/rmresource/playerSongPreview.png"></td>
    <td style="border: 0;"><img src="https://github.com/JonathanEsposito/SoTube/blob/master/rmresource/playerPurchase.png"></td> 
    <td style="border: 0;"><img src="https://github.com/JonathanEsposito/SoTube/blob/master/rmresource/playerContinuePlayingSong.png"></td>
  </tr>
</table>

- When a song is not yet bought or the user in not logged in, the user can preview the song for 30sec.
- If the song is not yet bought, the user can buy the song right in the player.
- When the song is succesfully bought, the user can immediatly continue playing the entire song.

<table style="width:100%">
  <tr style="border-top: 0;">
    <td style="border: 0;"><img src="https://github.com/JonathanEsposito/SoTube/blob/master/rmresource/playerShare.png"></td>
    <td style="border: 0;"><img src="https://github.com/JonathanEsposito/SoTube/blob/master/rmresource/playerShareMessage.png"></td> 
    <td style="border: 0;"><img src="https://github.com/JonathanEsposito/SoTube/blob/master/rmresource/playerAirplay.png"></td>
  </tr>
</table>

- The user can also share the song they are playing immediatly from the player.
- Sharing a song returns a message "I'm currently listening to [track title] by [artist name]" and a link to the current song on the only spotify player.
- If there is an airPlay device in the vecinity, the user can also stream their music to the device and control its volume.

### Account

comming soon

## How to compile and run the app

comming soon
