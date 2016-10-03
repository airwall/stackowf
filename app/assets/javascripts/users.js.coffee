jQuery ->
  new CarrierWaveCropper()

class CarrierWaveCropper
  constructor: ->
    $('#user_avatar_cropbox').Jcrop
      aspectRatio: 1
      setSelect: [0, 0, 200, 200]
      onSelect: @update
      onChange: @update

  update: (coords) =>
    $('#user_avatar_crop_x').val(coords.x)
    $('#user_avatar_crop_y').val(coords.y)
    $('#user_avatar_crop_w').val(coords.w)
    $('#user_avatar_crop_h').val(coords.h)
    @updatePreview(coords)

  updatePreview: (coords) =>
    $('#user_avatar_previewbox').css
      width: Math.round(100/coords.w * $('#user_avatar_cropbox').width()) + 'px'
      height: Math.round(100/coords.h * $('#user_avatar_cropbox').height()) + 'px'
      marginLeft: '-' + Math.round(100/coords.w * coords.x) + 'px'
      marginTop: '-' + Math.round(100/coords.h * coords.y) + 'px'
