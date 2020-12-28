import * as PaddleClient from '@/resources/paddle'
import { action, query, silence, M } from 'vuexi'

const GENERATE_PAY_LINK = M.of('GENERATE_PAY_LINK')
const PADDLE_CHECKOUT = M.of('PADDLE_CHECKOUT')

export default {
  state: {
    isGeneratePayLinkLoading: false,
    generatePayLinkError: null,
    isPaddleCheckoutErrorLoading: false,
    paddleCheckoutError: null
  },
  actions: {
    generatePayLink: query(GENERATE_PAY_LINK, PaddleClient.generatePayLink),
    paddleCheckout: query(PADDLE_CHECKOUT, PaddleClient.paddleCheckout)
  },
  mutations: {
    ...action(GENERATE_PAY_LINK, 'isGeneratePayLinkLoading', '', 'generatePayLinkError', silence),
    ...action(PADDLE_CHECKOUT, 'isPaddleCheckoutErrorLoading', '', 'isPaddleCheckoutErrorLoading', silence)
  }
}
