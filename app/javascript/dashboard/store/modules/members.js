import * as MembersClient from '@/resources/members'
import { action, success, query, push, removeById, M, silence, assignById } from 'vuexi'

const QUERY_PROJECT_MEMBERS = M.of('QUERY_PROJECT_MEMBERS')
const INVITE_MEMBER = M.of('INVITE_MEMBER')
const DESTROY_MEMBER = M.of('DESTROY_MEMBER')
const UPDATE_MEMBER = M.of('UPDATE_MEMBER')
const RESEND_INVITE = M.of('RESEND_INVITE')
const GET_INVITE = M.of('GET_INVITE')
const CONFIRM_INVITE = M.of('CONFIRM_INVITE')

export default {
  state: {
    members: [],
    project: null,
    isQueryMembersLoading: false,
    queryMembersError: null,
    isQueryInviteMemberLoading: false,
    queryInviteMemberError: null,
    isDestroyMemberLoading: false,
    queryDestroyMemberError: null,
    isUpdateMemberLoading: false,
    updateMemberError: null,
    isResendInviteLoading: false,
    resendInviteError: null,
    isGetInviteLoading: false,
    isConfirmInviteLoading: false,
    getInviteError: null,
    confirmInviteError: null
  },
  getters: {
    notCurrentUser (state) {
      return state.members.filter((m) => !m.current_user)
    }
  },
  actions: {
    queryMembers: query(QUERY_PROJECT_MEMBERS, MembersClient.getMembers),
    inviteMember: query(INVITE_MEMBER, MembersClient.inviteMember),
    updateMember: query(UPDATE_MEMBER, MembersClient.updateMember),
    resendInvite: query(RESEND_INVITE, MembersClient.inviteMember),
    removeMember: query(DESTROY_MEMBER, MembersClient.destroyMember),
    getProject: query(GET_INVITE, MembersClient.getProjectByInvite),
    confirmInvite: query(CONFIRM_INVITE, MembersClient.confirmInvite)
  },
  mutations: {
    ...action(QUERY_PROJECT_MEMBERS, 'isQueryMembersLoading', 'members', 'queryMembersError', success),
    ...action(INVITE_MEMBER, 'isQueryInviteMemberLoading', 'members', 'queryInviteMemberError', push),
    ...action(DESTROY_MEMBER, 'isDestroyMemberLoading', 'members', 'queryDestroyMemberError', removeById),
    ...action(UPDATE_MEMBER, 'isUpdateMemberLoading', 'members', 'updateMemberError', assignById),
    ...action(RESEND_INVITE, 'isResendInviteLoading', '', 'resendInviteError', silence),
    ...action(GET_INVITE, 'isGetInviteLoading', 'project', 'getInviteError', success),
    ...action(CONFIRM_INVITE, 'isConfirmInviteLoading', 'project', 'confirmInviteError', success)
  }
}
