﻿#pragma warning disable 1591
//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated by a tool.
//     Runtime Version:4.0.30319.18444
//
//     Changes to this file may cause incorrect behavior and will be lost if
//     the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace ImportHWSFromExcel
{
	using System.Data.Linq;
	using System.Data.Linq.Mapping;
	using System.Data;
	using System.Collections.Generic;
	using System.Reflection;
	using System.Linq;
	using System.Linq.Expressions;
	using System.ComponentModel;
	using System;
	
	
	[global::System.Data.Linq.Mapping.DatabaseAttribute(Name="DOS")]
	public partial class BDConnectionDataContext : System.Data.Linq.DataContext
	{
		
		private static System.Data.Linq.Mapping.MappingSource mappingSource = new AttributeMappingSource();
		
    #region Extensibility Method Definitions
    partial void OnCreated();
    #endregion
		
		public BDConnectionDataContext() : 
				base(global::ImportHWSFromExcel.Properties.Settings.Default.DOSConnectionString, mappingSource)
		{
			OnCreated();
		}
		
		public BDConnectionDataContext(string connection) : 
				base(connection, mappingSource)
		{
			OnCreated();
		}
		
		public BDConnectionDataContext(System.Data.IDbConnection connection) : 
				base(connection, mappingSource)
		{
			OnCreated();
		}
		
		public BDConnectionDataContext(string connection, System.Data.Linq.Mapping.MappingSource mappingSource) : 
				base(connection, mappingSource)
		{
			OnCreated();
		}
		
		public BDConnectionDataContext(System.Data.IDbConnection connection, System.Data.Linq.Mapping.MappingSource mappingSource) : 
				base(connection, mappingSource)
		{
			OnCreated();
		}
		
		[global::System.Data.Linq.Mapping.FunctionAttribute(Name="dbo.usp_addNewHWSMember")]
		public int usp_addNewHWSMember([global::System.Data.Linq.Mapping.ParameterAttribute(DbType="Xml")] System.Xml.Linq.XElement newXML, [global::System.Data.Linq.Mapping.ParameterAttribute(Name="Result", DbType="VarChar(10)")] ref string result)
		{
			IExecuteResult result1 = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), newXML, result);
			result = ((string)(result1.GetParameterValue(1)));
			return ((int)(result1.ReturnValue));
		}
	}
}
#pragma warning restore 1591