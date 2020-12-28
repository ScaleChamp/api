<template>
  <div>
    <LoadingTab v-if="isQueryMembersLoading"/>
    <template v-else-if="queryMembersError">{{ queryMembersError.message }}</template>
    <template v-else>
      <h1 class="text-4xl">{{ $t('members') }}</h1>
      <template v-if="notCurrentUser.length">
        <section class="flex items-center justify-between">
          <p class="text-xl long-and-truncated" :title="$t('members_page.info')">
            {{ $t('members_page.info') }}
          </p>
          <BaseButton class="bg-primary hover:bg-primary-100 text-white" @click.prevent="showInviteModal">
            {{ $t('invite_member.invite') }}
          </BaseButton>
        </section>
        <BaseTable>
          <thead>
          <tr>
            <th>{{ $t('invite_member.email') }}</th>
            <th>{{ $t('invite_member.role') }}</th>
            <th>{{ $t('invite_member.state') }}</th>
            <th class="hidden lg:block">{{ $t('invite_member.created') }}</th>
            <th />
          </tr>
          </thead>
          <tbody>
          <tr v-for="member in notCurrentUser" :key="member.id">
            <td>
              <span
                    class="cursor-pointer text-primary"
                    @click="showUpdateMember(member)">
                {{ member.email }}
              </span>
            </td>
            <td>{{ $t(member.role) }}</td>
            <td>{{ $t(`invite_member.${member.state}`) }}</td>
            <td class="hidden lg:block">{{ member.created_at | fromNow($i18n.locale) }}</td>
            <td>
              <span v-if="removingMap[member.id]" class="text-gray-400 cursor-not-allowed">
                {{ $t('invite_member.removing') }}
              </span>
              <a v-else
                 href
                 class="text-red-600"
                 @click.prevent="removeMemberAndShowLoading({ id: member.id, projectId: $route.params.projectId })">
                {{ $t('invite_member.remove') }}
              </a>
            </td>
          </tr>
          </tbody>
        </BaseTable>
      </template>
      <template v-else>
        <div class="flex items-center justify-between pixel-sorting shadow-lg py-6 px-6 rounded-sm banner">
          <p class="text-xl text-white font-semibold long-and-truncated" :title="$t('members_page.info')">
            {{ $t('members_page.info') }}
          </p>
          <BaseButton class="bg-white" @click.prevent="showInviteModal">
            {{ $t('invite_member.invite') }}
          </BaseButton>
        </div>
      </template>
    </template>
  </div>
</template>

<script>
import { mapState, mapActions, mapGetters } from 'vuex'
import Vue from 'vue'

export default {
  data () {
    return {
      email: '',
      links: null,
      removingMap: {}
    }
  },
  computed: {
    ...mapGetters('members', ['notCurrentUser']),
    ...mapState('members', [
      'members',
      'isQueryMembersLoading',
      'queryMembersError'
    ]),
    ...mapState('project', [
      'project'
    ])
  },
  methods: {
    ...mapActions({
      queryMembers: 'members/queryMembers',
      inviteMember: 'members/inviteMember',
      removeMember: 'members/removeMember'
    }),
    async removeMemberAndShowLoading (member) {
      Vue.set(this.removingMap, member.id, true)
      await this.removeMember(member)
      Vue.delete(this.removingMap, member.id)
    },
    async showUpdateMember (member) {
      try {
        await this.$modal.show(() => import(/* webpackPrefetch: 10 */ '@/modals/UpdateMemberModal'), { member })
      } catch (err) {
      } finally {
        this.$modal.hide()
      }
    },
    async showInviteModal () {
      try {
        await this.$modal.show(() => import(/* webpackPrefetch: 10 */ '@/modals/InviteMemberModal'))
      } catch (err) {
      } finally {
        this.$modal.hide()
      }
    }
  },
  created () {
    const { projectId } = this.$route.params
    this.queryMembers({ projectId })
  }
}
</script>
