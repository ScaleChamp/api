import * as SupportClient from '@/resources/support'
import { action, silence, query, M } from 'vuexi'

const CREATE_SUPPORT_TICKET = M.of('CREATE_SUPPORT_TICKET')

export default {
  state: {
    createTicketError: null,
    isCreateTicketLoading: false
  },
  actions: {
    createTicket: query(CREATE_SUPPORT_TICKET, SupportClient.createTicket)
  },
  mutations: {
    ...action(CREATE_SUPPORT_TICKET, 'isCreateTicketLoading', '', 'createTicketError', silence)
  }
}
