import Vue from 'vue'
import VueI18n from 'vue-i18n'
import Cookies from 'js-cookie'
import en from './locales/en.json'
import ru from './locales/ru.json'
import uk from './locales/uk.json'

Vue.use(VueI18n)

const dateTimeFormats = {
  en: {
    short: {
      year: 'numeric',
      month: 'short',
      day: 'numeric'
    },
    accurate: {
      year: 'numeric',
      month: 'short',
      day: 'numeric',
      hour: 'numeric',
      minute: 'numeric',
      second: true,
      hour12: true
    },
    long: {
      year: 'numeric',
      month: 'short',
      day: 'numeric',
      hour: 'numeric',
      minute: 'numeric',
      hour12: true
    }
  },
  ru: {
    short: {
      year: 'numeric',
      month: 'short',
      day: 'numeric'
    },
    accurate: {
      year: 'numeric',
      month: 'short',
      day: 'numeric',
      hour: 'numeric',
      minute: 'numeric',
      second: true
    },
    long: {
      year: 'numeric',
      month: 'short',
      day: 'numeric',
      hour: 'numeric',
      minute: 'numeric'
    }
  }
}

dateTimeFormats.uk = dateTimeFormats.ru

const fallbackLocale = 'en'

const opts = process.env.NODE_ENV === 'production' ? { domain: `.scalechamp.com` } : undefined

const i18n = new VueI18n({
  dateTimeFormats,
  locale: Cookies.get('locale', opts) || fallbackLocale,
  fallbackLocale,
  messages: {
    en,
    ru,
    uk
  }
})

const locale = 'locale'

export default new Proxy(i18n, {
  set (target, prop, value, receiver) {
    if (prop === locale) {
      Cookies.set(locale, value, opts)
    }
    target[prop] = value
    return true
  }
})
