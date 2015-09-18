require 'i18n'

I18n.enforce_available_locales = false
I18n.backend.store_translations(I18n.locale, {
  enum: {
    'Side' => {
      left: 'This is a left side'
    },

    'NewSide' => {
      center: 'This is a C side'
    },
    'Room::Side' => {
      left: 'This is a left side of the room'
    }
  }
})
