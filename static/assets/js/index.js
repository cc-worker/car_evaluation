/*!
 * 公共方法、对象、组件部分
 */
//时间格式化函数 eg:new Date().format('yyyy-MM-dd')
Date.prototype.format = function(layout){
	return Object.prototype.toString.call(layout) === "[object String]" ?
			layout.replace(/yyyy/gi,this.getFullYear())
				 .replace(/MM/g,(this.getMonth()<9 ? '0':'')+(this.getMonth()+1))
				 .replace(/dd/gi,(this.getDate()<10 ? '0':'')+this.getDate())
				 .replace(/HH/gi,(this.getHours()<10 ? '0':'')+this.getHours())
				 .replace(/mm/g,(this.getMinutes()<10 ? '0':'')+this.getMinutes())
				 .replace(/ss/g,(this.getSeconds()<10 ? '0':'')+this.getSeconds())
			:
				null
			;

}
//项目路劲
var root_path = '';
//公共data
var common_data = {
		tab:'list',
		searcher:{},
		busy:false
		
};

var common_grid = {
	
	
};
//公共vue方法
var common_method = {
		//验证功能
		validate:function(v){
			if(!v) return false;
			for(var i=0,o;o=v.rule[i];i++){
				if(o.type=='required'){
					if(v.value==='') return false;
				}else if(o.type=='regexp'){
					if(o.exp.test(v.value)==false) return false;
				}
			}
			return true;
		},
		//验证form中的所有元素，控制按钮是否disabled
		validAll:function(){
			for(var o in this.form){
				if(this.validate(this.form[o])==false) return false; 
			}
			return true;
		},
		//序列化参数
		serialize_param:function(){
			var p = {};
			for(var o in this.searcher){
				p[o] = this.searcher[o];
			}
			p.limit=this.grid.limit;
			p.page=this.grid.page;
			return p;
		},
		//列表查询功能
		search:function(l,p){
			var grid = this.grid;
			var param = this.serialize_param();
			if(l){param.limit = l;this.grid.limit = l;}
			if(p){param.page=p;this.grid.page = p;}
			$.post(root_path + this.grid.list_path,param,function(res){
				if(Array.isArray(res.data)){
					grid.data.splice(res.data.length);
					res.data.forEach(function(r,i){
						Vue.set(grid.data,i,Object.assign(r||{},{selected:r&&r.selected ? true :false}))
					});
					grid.total = res.total;
				}
			})
		},
		//列表插件 全选/全部选功能
		selectAll:function(el){
			this.grid.data.forEach(function(e,i,a){
				Vue.set(a,i,Object.assign(e,{selected:el}));
			});
		},
		//查询框重置功能
		clear_searcher:function(){
			for(var o in this.searcher){
				Vue.set(this.searcher,o,'');
			}
		},
		//删除功能 ids是要被删除行的[id1,id2,...].join(',')
		remove:function(id){
			var remove_path = root_path + this.grid.remove_path;
			var fun_search = this.search;
			layer.confirm('确定要删除吗？', {
				  btn: ['取消','确定'] 
				}, function(){
				  layer.closeAll();
				}, function(){
					$.post(remove_path,{ids:id+""},function(res){
						if(!res.data){
							layer.msg('删除失败', {icon: 2});
						}else{
							layer.msg('删除成功，本次删除了'+res.data[0]+'条数据', {icon: 1});
							fun_search();
						}					
					});
				});
		},
		//grid头部删除按钮
		ondelete:function(){
			var ids = [];
			this.grid.data.forEach(function(e,i,a){
				e.selected&&ids.push(e.id);
			});
			if(ids.length==0){
				layer.msg('请选择数据', {icon: 3});
				return;
			}
			this.remove(ids.join());
		},
		//grid头部新增按钮
		onadd:function(){
			this.status = 1;
			for(var o in this.form){
				Vue.set(this.form,o,Object.assign(this.form[o],{value:this.form[o].init}));
			}
			this.add_in&&this.add_in();
			this.tab = 'detail';
		},
		//grid头部导出函数
		onexport:function(){
			
		},
		//行删除按钮点击触发
		fun_line_delete:function(item){
			this.remove(item.id);
		},
		//行查看按钮点击触发
		fun_line_look:function(item){
			this.status = 0;
			this.look_in&&this.look_in(item);
//			for(var o in item){
//				this.form[o]&&Vue.set(this.form,o,Object.assign(this.form[o]||{},{value:item[o]}));
//			}
			for(var o in this.form){
				Vue.set(this.form,o,Object.assign(this.form[o]||{},{value:item[o]||''}));
			}
			this.tab='detail';
		},
		//行编辑按钮点击触发
		fun_line_edit:function(item){
			this.status = 1;
			this.edit_in&&this.edit_in(item);
			for(var o in item){
				this.form[o]&&Vue.set(this.form,o,Object.assign(this.form[o]||{},{value:item[o]}));
			}
			this.tab='detail';
		},
		//保存按钮
		save:function(){
			var server = this;
			this.busy = true;
			if(!this.validAll()) {
				layer.msg('请填写所有内容', {icon: 2});
				return;
			}
			var p = {};
			for(var o in  this.form){
				p[o] = Object.prototype.toString.call(this.form[o].value)==='[object Date]' ? this.form[o].value.format('yyyy-MM-dd HH:mm:ss'):this.form[o].value;
			}
			//保存内嵌方法
			if(this.save_in) this.save_in(p);
			$.post(root_path + this.grid.save_path,p,function(res){
				server.busy  = false;
				if(!res.data||!res.data.id){
					layer.msg('保存失败', {icon: 2});
				}else{
					server.search();
					for(var o in server.form){
						res.data[o]&&Vue.set(server.form,o,Object.assign(server.form[o],{value:res.data[o]}));
					}
					layer.msg('保存成功', {icon: 1});
					
				}
			});
		},
		turn_page:function(num){
			  if(num<0){
				  switch(num){
				  	case -1:{this.grid.page=1;break;}
				  	case -2:{this.grid.page=Math.ceil(this.grid.total/this.grid.limit);break;}
				  	case -3:{if(this.grid.page!=1)this.grid.page--;break;}
				  	case -4:{if(this.grid.page!=Math.ceil(this.grid.total/this.grid.limit))this.grid.page++;break;}
				  	default:break;
				  }
			  }else{
				  this.grid.page = num;
			  }
			  this.search(this.grid.limit,this.grid.page);
		},
}

/*!
 * my-select组件
 * options 数据源，数组格式 
 * v-model 双向绑定数据
 * eg. <my-select :options="list" v-model="message" ></my-select>
 */
Vue.component('my-select', {
	 props : ['options','value'],
	 template : "<select v-bind:value='value' v-on:input='updateValue($event.target.value)' class='bs-select form-control' ><option :value='option.id' :key='option.id' v-for='option in options'>{{ option.name }}</option></select>",
	 methods:{
		 updateValue:function(v){
			 this.$emit('input', v);
		 },
	 },
	 updated:function(){
		 var that = this;
		 $(this.$el).selectpicker('refresh');
		 $(this.$el).selectpicker().on('changed.bs.select', function (e,q) {
			 that.updateValue(that.options[q].id);
		 });
		 $(this.$el).selectpicker('val',this.value);
	 },
	 mounted:function(){
		 var dom = $(this.$el);
		 var that = this;
		 //this.$nextTick(function () {
			 dom.selectpicker().on('changed.bs.select', function (e,q) {
				 that.updateValue(that.options[q].id);
					 });
			 dom.selectpicker('val',that.value);
		 //});
	 }
	 
});


var datepicker_html = 
 '<div class="input-group  date date-picker" data-date-format="yyyy-mm-dd" style="width:100%">'
+'	<input type="text" class="form-control" readonly="" v-bind:value="value" v-on:input="updateValue($event.target.value)" ref="input">'
+'		<span class="input-group-btn">'
+'    		<button class="btn default" type="button">'
+'        		<i class="fa fa-calendar"></i>'
+'    		</button>'
+'		</span>'
+'</div>';
Vue.component('my-datepicker', {
	 props : ['value'],
	 template :datepicker_html,
	 methods:{
		 updateValue:function(v){
			 this.$emit('input', v);
		 },
	 },
	 mounted:function(){
		 var self = this;
		 $(self.$el).datepicker({
			 startView: 1,
	         todayHighlight: true,
	         todayBtn: "linked",
			 autoclose:true
		 }).on('changeDate', function(e) {
            var date = e.format('yyyy-mm-dd');
            self.updateValue(date);
         });
	 }
});



var datetimepicker_html = 
'<div class="input-group date form_datetime bs-datetime"  data-date-format="yyyy-mm-dd hh:ii:ss">'+
'	<input class="form-control" size="16" type="text" value="" readonly=""  v-bind:value="value" v-on:input="updateValue($event.target.value)">'+
'	<span class="input-group-addon">'+
'	    <button class="btn default date-reset" type="button">'+
'	        <i class="fa fa-times"></i>'+
'	    </button>'+
'	</span>'+
'	<span class="input-group-addon">'+
'	    <button class="btn default date-set" type="button">'+
'	        <i class="fa fa-calendar"></i>'+
'	    </button>'+
'	</span>'+
'</div>';
Vue.component('my-datetimepicker', {
	 props : ['value'],
	 template :datetimepicker_html,
	 methods:{
		 updateValue:function(v){
			 this.$emit('input', v);
		 },
	 },
	 mounted:function(){
		 var self = this;
		 
		 $(self.$el).datetimepicker({
			  format:'yyyy-mm-dd hh:ii:ss',
			  autoclose:true,
			  todayHighlight:true,
			  startView: 2,
			  defaultDate:new Date().format('yyyy-MM-dd hh:mm:ss')
		  }).on('changeDate', function(e) {
	            var date = 	new Date(e.date).format('yyyy-MM-dd hh:mm:ss');
	            self.updateValue(date);
	      });
		 
	 }
});

/*!
 * my-pager 分页组件
 * grid 对应js中grid 
 * search 对应公用search函数
 * eg. <my-pager :grid="grid" :search="search" ></my-pager>
 */
var pager_html = '<div class="row">				    <div class="col-md-5 col-sm-12">				        <div class="dataTables_paginate paging_bootstrap_full_number" style="height:60px">				            <div class="pagination">				                <label>				                    <select name="sample_1_length" aria-controls="sample_1" class="form-control input-xsmall input-inline" v-model="grid.limit" v-on:input=\'search($event.target.value)\'>				                        <option value="5">5</option>				                        <option value="10">10</option>				                        <option value="20">20</option>				                        <option value="50">50</option><option value="100">100</option><option value="500">500</option></select>				                </label>				            </div>				        </div>				    </div>			  		<div class="col-md-7 col-sm-12">					        <div class="dataTables_paginate paging_bootstrap_full_number" style="text-align:right">					            <ul class="pagination" style="visibility: visible;">					                <li class="prev" >					                    <a  title="首页" v-on:click="turn_page(-1)">					                        <i class="fa fa-angle-double-left"></i>					                    </a>					                </li>					                <li class="prev" >					                    <a  title="上一页" v-on:click.self="turn_page(-3)">					                        <i class="fa fa-angle-left"></i>					                    </a>					                </li>					                <li v-for="num in Math.min(5,Math.ceil(grid.total/grid.limit))" v-bind:class="{\'active\':grid.page==(Math.ceil(grid.total/grid.limit)<=5?num:(grid.page+2>Math.ceil(grid.total/grid.limit)?Math.ceil(grid.total/grid.limit)-5+num:(grid.page-2<1?num:grid.page+num-3)))}">					                    <a v-on:click.self="turn_page(Math.ceil(grid.total/grid.limit)<=5?num:(grid.page+2>Math.ceil(grid.total/grid.limit)?Math.ceil(grid.total/grid.limit)-5+num:(grid.page-2<1?num:grid.page+num-3)))">					                    {{Math.ceil(grid.total/grid.limit)					                        <=5?num:(grid.page+2>Math.ceil(grid.total/grid.limit)?Math.ceil(grid.total/grid.limit)-5+num:(grid.page-2					                            <1?num:grid.page+num-3))}}</a></li>					                <li class="next">					                    <a  title="下一页" v-on:click="turn_page(-4)">					                        <i class="fa fa-angle-right"></i>					                    </a>					                </li>					                <li class="next" >					                    <a  title="尾页" v-on:click="turn_page(-2)">					                        <i class="fa fa-angle-double-right"></i>					                    </a>					                </li>					                <li class="pull-right no-border">					                    <p class="form-control-static">&nbsp;&nbsp;&nbsp;&nbsp;共					                        <strong>{{grid.total}}</strong>条</p></li>					            </ul>					        </div>					    </div>					</div>';
Vue.component('my-pager', {
	 props : ['grid','search'],
	 template : pager_html,
	 methods:{
		 turn_page:function(num){
			  if(num<0){
				  switch(num){
				  	case -1:{this.grid.page=1;break;}
				  	case -2:{this.grid.page=Math.ceil(this.grid.total/this.grid.limit);break;}
				  	case -3:{if(this.grid.page!=1)this.grid.page-=1;break;}
				  	case -4:{if(this.grid.page!=Math.ceil(this.grid.total/this.grid.limit))this.grid.page+=1;break;}
				  	default:break;
				  }
			  }else{
				  this.grid.page = num;
			  }
			  this.search(this.grid.limit,this.grid.page);
		  }
 
	 }
	 
});


/*!
 * my-grid 列表组件
 * grid 对应js中grid 
 *
 * eg. <my-grid :grid='grid' :fun_line_look='fun_line_look' :fun_line_edit='fun_line_edit' :fun_line_delete='fun_line_delete'></my-grid>
 */
var grid_html = '<div id="sample_1_wrapper" class="dataTables_wrapper no-footer">		            		            <div class="table-scrollable">		              <table class="table table-striped table-bordered table-hover dataTable no-footer" id="sample_1" role="grid" aria-describedby="sample_1_info">		                <thead>		                  <tr role="row">		                    <th class="table-checkbox sorting_disabled" @click.stop v-if="grid.selectable">		                      	<label class="mt-checkbox mt-checkbox-outline">		                        	<input type="checkbox" @click="selectAll($event.target.checked)">		                        	<span></span>		                    	</label>		                      </th>		                    <th class="sorting_disabled" style="width:10px">序号</th>		                    <th class="sorting_disabled" v-for="c in grid.column" v-bind:class="c._class">{{c.name}}</th>		                    <th class="sorting_disabled">操作</th></tr>		                </thead>		                <tbody>		                  <tr class="gradeX odd" role="row" v-for="(d,i) in grid.data">		                    <td style="width:8px !important" @click.stop="d.selected=!d.selected" v-if="grid.selectable">		                      <div class="checker">		                        <span v-bind:class="{\'checked\':d.selected}">		                          	<label class="mt-checkbox mt-checkbox-outline">			                        	<input type="checkbox" v-model="d.selected">			                        	<span></span>			                    	</label>		                        </span>		                      </div>		                    </td>		                    <td>{{(grid.page-1)*grid.limit+i+1}}</td>		                    <td v-for="c in grid.column" v-bind:class="c._class">{{d[c.code]}}</td>		                    <td>		                      <a class="btn btn-circle btn-xs blue-madison" title="查看" v-if="grid.line_look(d)" @click="fun_line_look(d)">查看</a>		                      <a class="btn btn-circle btn-xs green-meadow" title="修改" v-if="grid.line_edit(d)" @click="fun_line_edit(d)">修改</a>		                      <a class="btn btn-circle btn-xs red-sunglo" title="删除" v-if="grid.line_delete(d)" @click="fun_line_delete(d)">删除</a>		                    </td>		                  </tr>		                </tbody>		              </table>		            </div>		            		           </div>';
Vue.component('my-grid', {
	props : ['grid','fun_line_look','fun_line_edit','fun_line_delete'],
	template : grid_html,
	methods:{
		selectAll:function(el){
			this.grid.data.forEach(function(e,i,a){
				Vue.set(a,i,Object.assign(e,{selected:el}))
			});
		},
	}
});


/*!
 * my-fun 功能按钮组件
 * grid 对应js中grid 
 *
 * eg. <my-fun :grid='grid' :onadd='onadd' :ondelete='ondelete'></my-fun>
 */
var fun_html = '<div class="actions" style="padding:10px 20px 0px 20px">             		<div class="btn-group btn-group-devided" data-toggle="buttons">			        <button class="btn btn-circle blue" v-show="grid.addable" style="margin-right:10px" @click="onadd()">		                  <i class="fa fa-plus"></i>&nbsp;添加</button>		                <button class="btn btn-circle red" v-show="grid.removable" style="margin-right:10px" @click="ondelete()">		                  <i class="fa fa-remove"></i>&nbsp;删除</button>		                <button class="btn btn-circle green" v-show="grid.exportable" style="margin-right:10px">		                  <i class="fa fa-file"></i>&nbsp;导出</button>		               </div>			</div>';
Vue.component('my-fun', {
	props : ['grid','onadd','ondelete','onexport'],
	template : fun_html,
	methods:{
		
	}
});

