<template>
  <div class="app-home">
    <div class="app-centre">
       <div class="app-Tag-row app-Tag-row-panel">
       <div class="app-form">
    <el-form :inline="true"  class="demo-form-inline" ref="QueryForm" :model="QueryForm">
{f_queryformitem}
      <el-form-item class="btnQuery">
        <el-button type="primary"  @click="Query">��ѯ</el-button>
      </el-form-item>
      <el-form-item class="btnQuery">
		<el-button  @click="reset">����</el-button>
      </el-form-item>
    </el-form>
       </div>
       <div class="form-bar" {m_Istool}>
    <el-button-group>
   <el-button type="primary" icon="el-icon-plus" @click="BarAdd">����</el-button>
   <el-button type="primary" icon="el-icon-edit" @click="BarEdit">�༭</el-button>
   <el-button type="primary" icon="el-icon-delete" @click="Bardelete">ɾ��</el-button>
   </el-button-group>
       </div>
     <div class="app-card-body app-card-list ">
        <el-table    :data="RoletableData"  style="width: 100%"
         v-loading="loading"
        @selection-change='SelectedChange'
        header-row-class-name="app_heard"
        row-class-name=''
        element-loading-text="ƴ��������"
        element-loading-spinner="el-icon-loading"
        element-loading-background="white"
       >
            <el-table-column prop="id"  type="selection" align="center"  width="40"></el-table-column><!-- BEGIN FieldList1 -->
            <el-table-column prop="{f_name}" label="{f_note}" align="center"></el-table-column><!-- END FieldList1 -->
      <el-table-column label="����" width="180"  align="center" {m_Istool}>
        <template slot-scope="scope" >
          <div><a  @click="AppEdit(scope.$index, scope.row)">�༭</a>
          <div class="ivu-divider ivu-divider-vertical ivu-divider-default"></div>
           <a  @click="AppDelete(scope.$index, scope.row)">ɾ��</a>
          </div>
      </template>
    </el-table-column>
        </el-table>
        <div class="app-pagination">
         <elPagination :url='url' ref="Page" :parameter='QueryForm'  v-on:get="(data) => { RoletableData = data }"  v-on:loading='(isloading) => { loading = isloading }' ></elPagination>
        </div>
       </div>
      </div>
    </div>
    <el-dialog
      title="�༭"
      @close="resetdialog"
      :append-to-body='true'
      :visible.sync="dialogVisible"
      width="1000px">
      <el-form :model="ruleForm" class="demo-form-inline" :inline="true" label-width="80px" :rules="rules" ref='ruleForm'>
{dlog_formItem}
    </el-form>
      <span slot="footer" class="dialog-footer">
        <el-button @click="dialogVisible = false">ȡ ��</el-button>
        <el-button type="primary" @click="submitForm">ȷ ��</el-button>
      </span>
    </el-dialog>
  </div>
</template>
<script>
import elPagination from '@/components/Pagination'
export default {
  components: { elPagination },
  data () {
    return {
      url: '/api/{t_name}',
      RoletableData: [],
      loading: true, // loading����
      QueryForm: {{b_queryparameter}},
      dialogVisible: false, // dialog��ʾ
      rules: { // ����֤
{p_verification}
      },
      ruleForm: {}, // ��ģ��
      Isedit: false, // �Ƿ�༭
      TableSelect: []
    }
  },
  created  () {

  },
  methods: {
    // ��ѯ
    Query () {
      this.$refs.Page.refresh()
    },
    // ���༭
    AppEdit (index, row) {
      this.Isedit = true
      this.dialogVisible = true
      this.$nextTick(() => {
        this.ruleForm = JSON.parse(JSON.stringify(row))
      })
    },
    // ����������
    BarAdd () {
      this.dialogVisible = true
      this.Isedit = false
      this.$nextTick(() => {
        this.ruleForm = {}
      })
    },
    // ���ɾ��
    AppDelete (index, row) {
      this.$confirm('�˲�����ɾ����ѡ����, �Ƿ����?', '��ʾ', {
        confirmButtonText: 'ȷ��',
        cancelButtonText: 'ȡ��',
        type: 'warning'
      }).then(() => {
        this.dalete([row])
      }).catch(() => {})
    },
    // ������ɾ��
    Bardelete () {
      if (this.TableSelect.length > 0) {
        this.$confirm('�˲�����ɾ����ѡ����, �Ƿ����?', '��ʾ', {
          confirmButtonText: 'ȷ��',
          cancelButtonText: 'ȡ��',
          type: 'warning'
        }).then(() => {
          this.dalete(this.TableSelect)
        }).catch(() => {})
      } else {
        this.$notify({
          title: '��ʾ',
          message: '��ѡ�к�ɾ��',
          duration: 2000,
          type: 'error'
        })
      }
    },
    // �������༭
    BarEdit () {
      if (this.TableSelect.length === 1) {
        this.AppEdit(null, this.TableSelect[0])
        this.dialogVisible = true
        this.Isedit = true
      } else {
        this.$notify({
          title: '��ʾ',
          message: '��ѡ��һ�к�༭',
          duration: 2000,
          type: 'error'
        })
      }
    },
    // ���ѡ��
    SelectedChange (selection) {
      this.TableSelect = selection
    },
    // ����
    reset () {
      this.$refs.QueryForm.resetFields()
      this.$refs.Page.refresh()
    },
    // ���dialog��
    resetdialog () {
      this.$refs.ruleForm.resetFields()
      this.$refs.ruleForm.clearValidate()
    },
    // ���ύ
    submitForm () {
      this.$refs.ruleForm.validate((valid) => {
        if (valid) {
          if (this.Isedit) {
            this.update()
          } else { this.Add() }
        } else {
          return false
        }
      })
    },
    // ��ӷ���
    Add () {
      this.$refs.Page.add(JSON.parse(JSON.stringify(this.ruleForm)))
      this.dialogVisible = false
    },
    // ���·���
    update () {
      this.$refs.Page.edit(JSON.parse(JSON.stringify(this.ruleForm)))
      this.dialogVisible = false
    },
    // ɾ������
    dalete (data) {
      this.$refs.Page.dalete(JSON.parse(JSON.stringify(data)))
    }
  }
}
</script>
