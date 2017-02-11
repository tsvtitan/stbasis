unit tsvInterpreterDb;

interface

uses UMainUnited, tsvInterpreterCore;

  { TFieldDef }
procedure TFieldDef_Create(var Value: Variant; Args: TArguments);
procedure TFieldDef_CreateField(var Value: Variant; Args: TArguments);
procedure TFieldDef_Read_InternalCalcField(var Value: Variant; Args: TArguments);
procedure TFieldDef_Write_InternalCalcField(const Value: Variant; Args: TArguments);
procedure TFieldDef_Read_DataType(var Value: Variant; Args: TArguments);
procedure TFieldDef_Read_FieldClass(var Value: Variant; Args: TArguments);
procedure TFieldDef_Read_FieldNo(var Value: Variant; Args: TArguments);
procedure TFieldDef_Read_Name(var Value: Variant; Args: TArguments);
procedure TFieldDef_Read_Precision(var Value: Variant; Args: TArguments);
procedure TFieldDef_Write_Precision(const Value: Variant; Args: TArguments);
procedure TFieldDef_Read_Required(var Value: Variant; Args: TArguments);
procedure TFieldDef_Read_Size(var Value: Variant; Args: TArguments);

  { TFieldDefs }
procedure TFieldDefs_Create(var Value: Variant; Args: TArguments);
procedure TFieldDefs_Add(var Value: Variant; Args: TArguments);
procedure TFieldDefs_Assign(var Value: Variant; Args: TArguments);
procedure TFieldDefs_Clear(var Value: Variant; Args: TArguments);
procedure TFieldDefs_Find(var Value: Variant; Args: TArguments);
procedure TFieldDefs_IndexOf(var Value: Variant; Args: TArguments);
procedure TFieldDefs_Update(var Value: Variant; Args: TArguments);
procedure TFieldDefs_Read_Count(var Value: Variant; Args: TArguments);
procedure TFieldDefs_Read_Items(var Value: Variant; Args: TArguments);

  { TField }
procedure TField_Create(var Value: Variant; Args: TArguments);
procedure TField_Assign(var Value: Variant; Args: TArguments);
procedure TField_Clear(var Value: Variant; Args: TArguments);
procedure TField_FocusControl(var Value: Variant; Args: TArguments);
procedure TField_GetData(var Value: Variant; Args: TArguments);
procedure TField_IsBlob(var Value: Variant; Args: TArguments);
procedure TField_IsValidChar(var Value: Variant; Args: TArguments);
procedure TField_RefreshLookupList(var Value: Variant; Args: TArguments);
procedure TField_SetData(var Value: Variant; Args: TArguments);
procedure TField_SetFieldType(var Value: Variant; Args: TArguments);
procedure TField_Validate(var Value: Variant; Args: TArguments);
procedure TField_Read_AsBoolean(var Value: Variant; Args: TArguments);
procedure TField_Write_AsBoolean(const Value: Variant; Args: TArguments);
procedure TField_Read_AsCurrency(var Value: Variant; Args: TArguments);
procedure TField_Write_AsCurrency(const Value: Variant; Args: TArguments);
procedure TField_Read_AsDateTime(var Value: Variant; Args: TArguments);
procedure TField_Write_AsDateTime(const Value: Variant; Args: TArguments);
procedure TField_Read_AsFloat(var Value: Variant; Args: TArguments);
procedure TField_Write_AsFloat(const Value: Variant; Args: TArguments);
procedure TField_Read_AsInteger(var Value: Variant; Args: TArguments);
procedure TField_Write_AsInteger(const Value: Variant; Args: TArguments);
procedure TField_Read_AsString(var Value: Variant; Args: TArguments);
procedure TField_Write_AsString(const Value: Variant; Args: TArguments);
procedure TField_Read_AsVariant(var Value: Variant; Args: TArguments);
procedure TField_Write_AsVariant(const Value: Variant; Args: TArguments);
procedure TField_Read_AttributeSet(var Value: Variant; Args: TArguments);
procedure TField_Write_AttributeSet(const Value: Variant; Args: TArguments);
procedure TField_Read_Calculated(var Value: Variant; Args: TArguments);
procedure TField_Write_Calculated(const Value: Variant; Args: TArguments);
procedure TField_Read_CanModify(var Value: Variant; Args: TArguments);
procedure TField_Read_CurValue(var Value: Variant; Args: TArguments);
procedure TField_Read_DataSet(var Value: Variant; Args: TArguments);
procedure TField_Write_DataSet(const Value: Variant; Args: TArguments);
procedure TField_Read_DataSize(var Value: Variant; Args: TArguments);
procedure TField_Read_DataType(var Value: Variant; Args: TArguments);
procedure TField_Read_DisplayName(var Value: Variant; Args: TArguments);
procedure TField_Read_DisplayText(var Value: Variant; Args: TArguments);
procedure TField_Read_EditMask(var Value: Variant; Args: TArguments);
procedure TField_Write_EditMask(const Value: Variant; Args: TArguments);
procedure TField_Read_EditMaskPtr(var Value: Variant; Args: TArguments);
procedure TField_Read_FieldNo(var Value: Variant; Args: TArguments);
procedure TField_Read_IsIndexField(var Value: Variant; Args: TArguments);
procedure TField_Read_IsNull(var Value: Variant; Args: TArguments);
procedure TField_Read_Lookup(var Value: Variant; Args: TArguments);
procedure TField_Write_Lookup(const Value: Variant; Args: TArguments);
procedure TField_Read_NewValue(var Value: Variant; Args: TArguments);
procedure TField_Write_NewValue(const Value: Variant; Args: TArguments);
procedure TField_Read_Offset(var Value: Variant; Args: TArguments);
procedure TField_Read_OldValue(var Value: Variant; Args: TArguments);
procedure TField_Read_Size(var Value: Variant; Args: TArguments);
procedure TField_Write_Size(const Value: Variant; Args: TArguments);
procedure TField_Read_Text(var Value: Variant; Args: TArguments);
procedure TField_Write_Text(const Value: Variant; Args: TArguments);
procedure TField_Read_Value(var Value: Variant; Args: TArguments);
procedure TField_Write_Value(const Value: Variant; Args: TArguments);
procedure TField_Read_Alignment(var Value: Variant; Args: TArguments);
procedure TField_Write_Alignment(const Value: Variant; Args: TArguments);
procedure TField_Read_CustomConstraint(var Value: Variant; Args: TArguments);
procedure TField_Write_CustomConstraint(const Value: Variant; Args: TArguments);
procedure TField_Read_ConstraintErrorMessage(var Value: Variant; Args: TArguments);
procedure TField_Write_ConstraintErrorMessage(const Value: Variant; Args: TArguments);
procedure TField_Read_DefaultExpression(var Value: Variant; Args: TArguments);
procedure TField_Write_DefaultExpression(const Value: Variant; Args: TArguments);
procedure TField_Read_DisplayLabel(var Value: Variant; Args: TArguments);
procedure TField_Write_DisplayLabel(const Value: Variant; Args: TArguments);
procedure TField_Read_DisplayWidth(var Value: Variant; Args: TArguments);
procedure TField_Write_DisplayWidth(const Value: Variant; Args: TArguments);
procedure TField_Read_FieldKind(var Value: Variant; Args: TArguments);
procedure TField_Write_FieldKind(const Value: Variant; Args: TArguments);
procedure TField_Read_FieldName(var Value: Variant; Args: TArguments);
procedure TField_Write_FieldName(const Value: Variant; Args: TArguments);
procedure TField_Read_HasConstraints(var Value: Variant; Args: TArguments);
procedure TField_Read_Index(var Value: Variant; Args: TArguments);
procedure TField_Write_Index(const Value: Variant; Args: TArguments);
procedure TField_Read_ImportedConstraint(var Value: Variant; Args: TArguments);
procedure TField_Write_ImportedConstraint(const Value: Variant; Args: TArguments);
procedure TField_Read_LookupDataSet(var Value: Variant; Args: TArguments);
procedure TField_Write_LookupDataSet(const Value: Variant; Args: TArguments);
procedure TField_Read_LookupKeyFields(var Value: Variant; Args: TArguments);
procedure TField_Write_LookupKeyFields(const Value: Variant; Args: TArguments);
procedure TField_Read_LookupResultField(var Value: Variant; Args: TArguments);
procedure TField_Write_LookupResultField(const Value: Variant; Args: TArguments);
procedure TField_Read_KeyFields(var Value: Variant; Args: TArguments);
procedure TField_Write_KeyFields(const Value: Variant; Args: TArguments);
procedure TField_Read_LookupCache(var Value: Variant; Args: TArguments);
procedure TField_Write_LookupCache(const Value: Variant; Args: TArguments);
procedure TField_Read_Origin(var Value: Variant; Args: TArguments);
procedure TField_Write_Origin(const Value: Variant; Args: TArguments);
procedure TField_Read_ReadOnly(var Value: Variant; Args: TArguments);
procedure TField_Write_ReadOnly(const Value: Variant; Args: TArguments);
procedure TField_Read_Required(var Value: Variant; Args: TArguments);
procedure TField_Write_Required(const Value: Variant; Args: TArguments);
procedure TField_Read_Visible(var Value: Variant; Args: TArguments);
procedure TField_Write_Visible(const Value: Variant; Args: TArguments);

  { TStringField }
procedure TStringField_Create(var Value: Variant; Args: TArguments);
procedure TStringField_Read_Value(var Value: Variant; Args: TArguments);
procedure TStringField_Write_Value(const Value: Variant; Args: TArguments);
procedure TStringField_Read_Transliterate(var Value: Variant; Args: TArguments);
procedure TStringField_Write_Transliterate(const Value: Variant; Args: TArguments);

  { TNumericField }
procedure TNumericField_Create(var Value: Variant; Args: TArguments);
procedure TNumericField_Read_DisplayFormat(var Value: Variant; Args: TArguments);
procedure TNumericField_Write_DisplayFormat(const Value: Variant; Args: TArguments);
procedure TNumericField_Read_EditFormat(var Value: Variant; Args: TArguments);
procedure TNumericField_Write_EditFormat(const Value: Variant; Args: TArguments);

  { TIntegerField }
procedure TIntegerField_Create(var Value: Variant; Args: TArguments);
procedure TIntegerField_Read_Value(var Value: Variant; Args: TArguments);
procedure TIntegerField_Write_Value(const Value: Variant; Args: TArguments);
procedure TIntegerField_Read_MaxValue(var Value: Variant; Args: TArguments);
procedure TIntegerField_Write_MaxValue(const Value: Variant; Args: TArguments);
procedure TIntegerField_Read_MinValue(var Value: Variant; Args: TArguments);
procedure TIntegerField_Write_MinValue(const Value: Variant; Args: TArguments);

  { TSmallintField }
procedure TSmallintField_Create(var Value: Variant; Args: TArguments);

  { TWordField }
procedure TWordField_Create(var Value: Variant; Args: TArguments);

  { TAutoIncField }
procedure TAutoIncField_Create(var Value: Variant; Args: TArguments);

  { TFloatField }
procedure TFloatField_Create(var Value: Variant; Args: TArguments);
procedure TFloatField_Read_Value(var Value: Variant; Args: TArguments);
procedure TFloatField_Write_Value(const Value: Variant; Args: TArguments);
procedure TFloatField_Read_Currency(var Value: Variant; Args: TArguments);
procedure TFloatField_Write_Currency(const Value: Variant; Args: TArguments);
procedure TFloatField_Read_MaxValue(var Value: Variant; Args: TArguments);
procedure TFloatField_Write_MaxValue(const Value: Variant; Args: TArguments);
procedure TFloatField_Read_MinValue(var Value: Variant; Args: TArguments);
procedure TFloatField_Write_MinValue(const Value: Variant; Args: TArguments);
procedure TFloatField_Read_Precision(var Value: Variant; Args: TArguments);
procedure TFloatField_Write_Precision(const Value: Variant; Args: TArguments);

  { TCurrencyField }
procedure TCurrencyField_Create(var Value: Variant; Args: TArguments);

  { TBooleanField }
procedure TBooleanField_Create(var Value: Variant; Args: TArguments);
procedure TBooleanField_Read_Value(var Value: Variant; Args: TArguments);
procedure TBooleanField_Write_Value(const Value: Variant; Args: TArguments);
procedure TBooleanField_Read_DisplayValues(var Value: Variant; Args: TArguments);
procedure TBooleanField_Write_DisplayValues(const Value: Variant; Args: TArguments);

  { TDateTimeField }
procedure TDateTimeField_Create(var Value: Variant; Args: TArguments);
procedure TDateTimeField_Read_Value(var Value: Variant; Args: TArguments);
procedure TDateTimeField_Write_Value(const Value: Variant; Args: TArguments);
procedure TDateTimeField_Read_DisplayFormat(var Value: Variant; Args: TArguments);
procedure TDateTimeField_Write_DisplayFormat(const Value: Variant; Args: TArguments);

  { TDateField }
procedure TDateField_Create(var Value: Variant; Args: TArguments);

  { TTimeField }
procedure TTimeField_Create(var Value: Variant; Args: TArguments);

  { TBinaryField }
procedure TBinaryField_Create(var Value: Variant; Args: TArguments);

  { TBytesField }
procedure TBytesField_Create(var Value: Variant; Args: TArguments);

  { TVarBytesField }
procedure TVarBytesField_Create(var Value: Variant; Args: TArguments);

  { TBCDField }
procedure TBCDField_Create(var Value: Variant; Args: TArguments);
procedure TBCDField_Read_Value(var Value: Variant; Args: TArguments);
procedure TBCDField_Write_Value(const Value: Variant; Args: TArguments);
procedure TBCDField_Read_Currency(var Value: Variant; Args: TArguments);
procedure TBCDField_Write_Currency(const Value: Variant; Args: TArguments);
procedure TBCDField_Read_MaxValue(var Value: Variant; Args: TArguments);
procedure TBCDField_Write_MaxValue(const Value: Variant; Args: TArguments);
procedure TBCDField_Read_MinValue(var Value: Variant; Args: TArguments);
procedure TBCDField_Write_MinValue(const Value: Variant; Args: TArguments);

  { TBlobField }
procedure TBlobField_Create(var Value: Variant; Args: TArguments);
procedure TBlobField_Assign(var Value: Variant; Args: TArguments);
procedure TBlobField_Clear(var Value: Variant; Args: TArguments);
procedure TBlobField_IsBlob(var Value: Variant; Args: TArguments);
procedure TBlobField_LoadFromFile(var Value: Variant; Args: TArguments);
procedure TBlobField_LoadFromStream(var Value: Variant; Args: TArguments);
procedure TBlobField_SaveToFile(var Value: Variant; Args: TArguments);
procedure TBlobField_SaveToStream(var Value: Variant; Args: TArguments);
procedure TBlobField_SetFieldType(var Value: Variant; Args: TArguments);
procedure TBlobField_Read_BlobSize(var Value: Variant; Args: TArguments);
procedure TBlobField_Read_Modified(var Value: Variant; Args: TArguments);
procedure TBlobField_Write_Modified(const Value: Variant; Args: TArguments);
procedure TBlobField_Read_Value(var Value: Variant; Args: TArguments);
procedure TBlobField_Write_Value(const Value: Variant; Args: TArguments);
procedure TBlobField_Read_Transliterate(var Value: Variant; Args: TArguments);
procedure TBlobField_Write_Transliterate(const Value: Variant; Args: TArguments);
procedure TBlobField_Read_BlobType(var Value: Variant; Args: TArguments);
procedure TBlobField_Write_BlobType(const Value: Variant; Args: TArguments);

  { TMemoField }
procedure TMemoField_Create(var Value: Variant; Args: TArguments);

  { TGraphicField }
procedure TGraphicField_Create(var Value: Variant; Args: TArguments);

  { TIndexDef }
procedure TIndexDef_Create(var Value: Variant; Args: TArguments);
procedure TIndexDef_Read_Expression(var Value: Variant; Args: TArguments);
procedure TIndexDef_Read_Fields(var Value: Variant; Args: TArguments);
procedure TIndexDef_Read_Name(var Value: Variant; Args: TArguments);
procedure TIndexDef_Read_Options(var Value: Variant; Args: TArguments);
procedure TIndexDef_Read_Source(var Value: Variant; Args: TArguments);
procedure TIndexDef_Write_Source(const Value: Variant; Args: TArguments);

  { TIndexDefs }
procedure TIndexDefs_Create(var Value: Variant; Args: TArguments);
procedure TIndexDefs_Add(var Value: Variant; Args: TArguments);
procedure TIndexDefs_Assign(var Value: Variant; Args: TArguments);
procedure TIndexDefs_Clear(var Value: Variant; Args: TArguments);
procedure TIndexDefs_FindIndexForFields(var Value: Variant; Args: TArguments);
procedure TIndexDefs_GetIndexForFields(var Value: Variant; Args: TArguments);
procedure TIndexDefs_IndexOf(var Value: Variant; Args: TArguments);
procedure TIndexDefs_Update(var Value: Variant; Args: TArguments);
procedure TIndexDefs_Read_Count(var Value: Variant; Args: TArguments);
procedure TIndexDefs_Read_Items(var Value: Variant; Args: TArguments);
procedure TIndexDefs_Read_Updated(var Value: Variant; Args: TArguments);
procedure TIndexDefs_Write_Updated(const Value: Variant; Args: TArguments);

  { TDataLink }
procedure TDataLink_Create(var Value: Variant; Args: TArguments);
procedure TDataLink_Edit(var Value: Variant; Args: TArguments);
procedure TDataLink_UpdateRecord(var Value: Variant; Args: TArguments);
procedure TDataLink_Read_Active(var Value: Variant; Args: TArguments);
procedure TDataLink_Read_ActiveRecord(var Value: Variant; Args: TArguments);
procedure TDataLink_Write_ActiveRecord(const Value: Variant; Args: TArguments);
procedure TDataLink_Read_BufferCount(var Value: Variant; Args: TArguments);
procedure TDataLink_Write_BufferCount(const Value: Variant; Args: TArguments);
procedure TDataLink_Read_DataSet(var Value: Variant; Args: TArguments);
procedure TDataLink_Read_DataSource(var Value: Variant; Args: TArguments);
procedure TDataLink_Write_DataSource(const Value: Variant; Args: TArguments);
procedure TDataLink_Read_DataSourceFixed(var Value: Variant; Args: TArguments);
procedure TDataLink_Write_DataSourceFixed(const Value: Variant; Args: TArguments);
procedure TDataLink_Read_Editing(var Value: Variant; Args: TArguments);
procedure TDataLink_Read_ReadOnly(var Value: Variant; Args: TArguments);
procedure TDataLink_Write_ReadOnly(const Value: Variant; Args: TArguments);
procedure TDataLink_Read_RecordCount(var Value: Variant; Args: TArguments);

  { TDataSource }
procedure TDataSource_Create(var Value: Variant; Args: TArguments);
procedure TDataSource_Edit(var Value: Variant; Args: TArguments);
procedure TDataSource_IsLinkedTo(var Value: Variant; Args: TArguments);
procedure TDataSource_Read_State(var Value: Variant; Args: TArguments);
procedure TDataSource_Read_AutoEdit(var Value: Variant; Args: TArguments);
procedure TDataSource_Write_AutoEdit(const Value: Variant; Args: TArguments);
procedure TDataSource_Read_DataSet(var Value: Variant; Args: TArguments);
procedure TDataSource_Write_DataSet(const Value: Variant; Args: TArguments);
procedure TDataSource_Read_Enabled(var Value: Variant; Args: TArguments);
procedure TDataSource_Write_Enabled(const Value: Variant; Args: TArguments);

  { TCheckConstraint }
procedure TCheckConstraint_Assign(var Value: Variant; Args: TArguments);
procedure TCheckConstraint_GetDisplayName(var Value: Variant; Args: TArguments);
procedure TCheckConstraint_Read_CustomConstraint(var Value: Variant; Args: TArguments);
procedure TCheckConstraint_Write_CustomConstraint(const Value: Variant; Args: TArguments);
procedure TCheckConstraint_Read_ErrorMessage(var Value: Variant; Args: TArguments);
procedure TCheckConstraint_Write_ErrorMessage(const Value: Variant; Args: TArguments);
procedure TCheckConstraint_Read_FromDictionary(var Value: Variant; Args: TArguments);
procedure TCheckConstraint_Write_FromDictionary(const Value: Variant; Args: TArguments);
procedure TCheckConstraint_Read_ImportedConstraint(var Value: Variant; Args: TArguments);
procedure TCheckConstraint_Write_ImportedConstraint(const Value: Variant; Args: TArguments);

  { TCheckConstraints }
procedure TCheckConstraints_Create(var Value: Variant; Args: TArguments);
procedure TCheckConstraints_Add(var Value: Variant; Args: TArguments);
procedure TCheckConstraints_Read_Items(var Value: Variant; Args: TArguments);
procedure TCheckConstraints_Write_Items(const Value: Variant; Args: TArguments);


  {TParams}
procedure TParams_ParamByName(var Value: Variant; Args: TArguments);


  { TDataSet }

procedure TDataSet_ActiveBuffer(var Value: Variant; Args: TArguments);
procedure TDataSet_Append(var Value: Variant; Args: TArguments);
procedure TDataSet_BookmarkValid(var Value: Variant; Args: TArguments);
procedure TDataSet_Cancel(var Value: Variant; Args: TArguments);
procedure TDataSet_CheckBrowseMode(var Value: Variant; Args: TArguments);
procedure TDataSet_ClearFields(var Value: Variant; Args: TArguments);
procedure TDataSet_Close(var Value: Variant; Args: TArguments);
procedure TDataSet_ControlsDisabled(var Value: Variant; Args: TArguments);
procedure TDataSet_CompareBookmarks(var Value: Variant; Args: TArguments);
procedure TDataSet_CreateBlobStream(var Value: Variant; Args: TArguments);
procedure TDataSet_CursorPosChanged(var Value: Variant; Args: TArguments);
procedure TDataSet_Delete(var Value: Variant; Args: TArguments);
procedure TDataSet_DisableControls(var Value: Variant; Args: TArguments);
procedure TDataSet_Edit(var Value: Variant; Args: TArguments);
procedure TDataSet_EnableControls(var Value: Variant; Args: TArguments);
procedure TDataSet_FieldByName(var Value: Variant; Args: TArguments);
procedure TDataSet_FindField(var Value: Variant; Args: TArguments);
procedure TDataSet_FindFirst(var Value: Variant; Args: TArguments);
procedure TDataSet_FindLast(var Value: Variant; Args: TArguments);
procedure TDataSet_FindNext(var Value: Variant; Args: TArguments);
procedure TDataSet_FindPrior(var Value: Variant; Args: TArguments);
procedure TDataSet_First(var Value: Variant; Args: TArguments);
procedure TDataSet_FreeBookmark(var Value: Variant; Args: TArguments);
procedure TDataSet_GetBookmark(var Value: Variant; Args: TArguments);
procedure TDataSet_GetCurrentRecord(var Value: Variant; Args: TArguments);
procedure TDataSet_GetFieldList(var Value: Variant; Args: TArguments);
procedure TDataSet_GetFieldNames(var Value: Variant; Args: TArguments);
procedure TDataSet_GotoBookmark(var Value: Variant; Args: TArguments);
procedure TDataSet_Insert(var Value: Variant; Args: TArguments);
procedure TDataSet_IsEmpty(var Value: Variant; Args: TArguments);
procedure TDataSet_IsLinkedTo(var Value: Variant; Args: TArguments);
procedure TDataSet_IsSequenced(var Value: Variant; Args: TArguments);
procedure TDataSet_Last(var Value: Variant; Args: TArguments);
procedure TDataSet_Locate(var Value: Variant; Args: TArguments);
procedure TDataSet_Lookup(var Value: Variant; Args: TArguments);
procedure TDataSet_MoveBy(var Value: Variant; Args: TArguments);
procedure TDataSet_Next(var Value: Variant; Args: TArguments);
procedure TDataSet_Open(var Value: Variant; Args: TArguments);
procedure TDataSet_Post(var Value: Variant; Args: TArguments);
procedure TDataSet_Prior(var Value: Variant; Args: TArguments);
procedure TDataSet_Refresh(var Value: Variant; Args: TArguments);
procedure TDataSet_Resync(var Value: Variant; Args: TArguments);
procedure TDataSet_Translate(var Value: Variant; Args: TArguments);
procedure TDataSet_UpdateCursorPos(var Value: Variant; Args: TArguments);
procedure TDataSet_UpdateRecord(var Value: Variant; Args: TArguments);
procedure TDataSet_Read_BOF(var Value: Variant; Args: TArguments);
procedure TDataSet_Read_Bookmark(var Value: Variant; Args: TArguments);
procedure TDataSet_Write_Bookmark(const Value: Variant; Args: TArguments);
procedure TDataSet_Read_CanModify(var Value: Variant; Args: TArguments);
procedure TDataSet_Read_DataSource(var Value: Variant; Args: TArguments);
procedure TDataSet_Read_DefaultFields(var Value: Variant; Args: TArguments);
procedure TDataSet_Read_Designer(var Value: Variant; Args: TArguments);
procedure TDataSet_Read_EOF(var Value: Variant; Args: TArguments);
procedure TDataSet_Read_FieldCount(var Value: Variant; Args: TArguments);
procedure TDataSet_Read_FieldDefs(var Value: Variant; Args: TArguments);
procedure TDataSet_Write_FieldDefs(const Value: Variant; Args: TArguments);
procedure TDataSet_Read_Fields(var Value: Variant; Args: TArguments);
procedure TDataSet_Write_Fields(const Value: Variant; Args: TArguments);
procedure TDataSet_Read_FieldValues(var Value: Variant; Args: TArguments);
procedure TDataSet_Write_FieldValues(const Value: Variant; Args: TArguments);
procedure TDataSet_Read_Found(var Value: Variant; Args: TArguments);
procedure TDataSet_Read_Modified(var Value: Variant; Args: TArguments);
procedure TDataSet_Read_RecordCount(var Value: Variant; Args: TArguments);
procedure TDataSet_Read_RecNo(var Value: Variant; Args: TArguments);
procedure TDataSet_Write_RecNo(const Value: Variant; Args: TArguments);
procedure TDataSet_Read_RecordSize(var Value: Variant; Args: TArguments);
procedure TDataSet_Read_State(var Value: Variant; Args: TArguments);
procedure TDataSet_Read_Filter(var Value: Variant; Args: TArguments);
procedure TDataSet_Write_Filter(const Value: Variant; Args: TArguments);
procedure TDataSet_Read_Filtered(var Value: Variant; Args: TArguments);
procedure TDataSet_Write_Filtered(const Value: Variant; Args: TArguments);
procedure TDataSet_Read_FilterOptions(var Value: Variant; Args: TArguments);
procedure TDataSet_Write_FilterOptions(const Value: Variant; Args: TArguments);
procedure TDataSet_Read_Active(var Value: Variant; Args: TArguments);
procedure TDataSet_Write_Active(const Value: Variant; Args: TArguments);
procedure TDataSet_Read_AutoCalcFields(var Value: Variant; Args: TArguments);
procedure TDataSet_Write_AutoCalcFields(const Value: Variant; Args: TArguments);

// TClientDataSet
procedure TClientDataSet_CreateDataSet(var Value: Variant; Args: TArguments);
procedure TClientDataSet_EmptyDataSet(var Value: Variant; Args: TArguments);
procedure TClientDataSet_SaveToFile(var Value: Variant; Args: TArguments);

implementation

uses Classes, Db, dbclient;

  { TFieldDef }

{ constructor Create(Owner: TFieldDefs; Name: string; DataType: TFieldType; Size: Word; Required: Boolean; FieldNo: Integer) }
procedure TFieldDef_Create(var Value: Variant; Args: TArguments);
begin
  Value := O2V(TFieldDef.Create(V2O(Args.Values[0]) as TFieldDefs, string(Args.Values[1]), Args.Values[2], Args.Values[3], Args.Values[4], Args.Values[5]));
end;

{  function CreateField(Owner: TComponent): TField; }
procedure TFieldDef_CreateField(var Value: Variant; Args: TArguments);
begin
  Value := O2V(TFieldDef(Args.Obj).CreateField(V2O(Args.Values[0]) as TComponent));
end;

{ property Read InternalCalcField: Boolean }
procedure TFieldDef_Read_InternalCalcField(var Value: Variant; Args: TArguments);
begin
  Value := TFieldDef(Args.Obj).InternalCalcField;
end;

{ property Write InternalCalcField(Value: Boolean) }
procedure TFieldDef_Write_InternalCalcField(const Value: Variant; Args: TArguments);
begin
  TFieldDef(Args.Obj).InternalCalcField := Value;
end;

{ property Read DataType: TFieldType }
procedure TFieldDef_Read_DataType(var Value: Variant; Args: TArguments);
begin
  Value := TFieldDef(Args.Obj).DataType;
end;

{ property Read FieldClass: TFieldClass }
procedure TFieldDef_Read_FieldClass(var Value: Variant; Args: TArguments);
begin
  Value := C2V(TFieldDef(Args.Obj).FieldClass);
end;

{ property Read FieldNo: Integer }
procedure TFieldDef_Read_FieldNo(var Value: Variant; Args: TArguments);
begin
  Value := TFieldDef(Args.Obj).FieldNo;
end;

{ property Read Name: string }
procedure TFieldDef_Read_Name(var Value: Variant; Args: TArguments);
begin
  Value := TFieldDef(Args.Obj).Name;
end;

{ property Read Precision: Integer }
procedure TFieldDef_Read_Precision(var Value: Variant; Args: TArguments);
begin
  Value := TFieldDef(Args.Obj).Precision;
end;

{ property Write Precision(Value: Integer) }
procedure TFieldDef_Write_Precision(const Value: Variant; Args: TArguments);
begin
  TFieldDef(Args.Obj).Precision := Value;
end;

{ property Read Required: Boolean }
procedure TFieldDef_Read_Required(var Value: Variant; Args: TArguments);
begin
  Value := TFieldDef(Args.Obj).Required;
end;

{ property Read Size: Word }
procedure TFieldDef_Read_Size(var Value: Variant; Args: TArguments);
begin
  Value := TFieldDef(Args.Obj).Size;
end;

  { TFieldDefs }

{ constructor Create(DataSet: TDataSet) }
procedure TFieldDefs_Create(var Value: Variant; Args: TArguments);
begin
  Value := O2V(TFieldDefs.Create(V2O(Args.Values[0]) as TDataSet));
end;

{  procedure Add(const Name: string; DataType: TFieldType; Size: Word; Required: Boolean); }
procedure TFieldDefs_Add(var Value: Variant; Args: TArguments);
begin
  TFieldDefs(Args.Obj).Add(Args.Values[0], Args.Values[1], Args.Values[2], Args.Values[3]);
end;

{  procedure Assign(FieldDefs: TFieldDefs); }
procedure TFieldDefs_Assign(var Value: Variant; Args: TArguments);
begin
  TFieldDefs(Args.Obj).Assign(V2O(Args.Values[0]) as TFieldDefs);
end;

{  procedure Clear; }
procedure TFieldDefs_Clear(var Value: Variant; Args: TArguments);
begin
  TFieldDefs(Args.Obj).Clear;
end;

{  function Find(const Name: string): TFieldDef; }
procedure TFieldDefs_Find(var Value: Variant; Args: TArguments);
begin
  Value := O2V(TFieldDefs(Args.Obj).Find(Args.Values[0]));
end;

{  function IndexOf(const Name: string): Integer; }
procedure TFieldDefs_IndexOf(var Value: Variant; Args: TArguments);
begin
  Value := TFieldDefs(Args.Obj).IndexOf(Args.Values[0]);
end;

{  procedure Update; }
procedure TFieldDefs_Update(var Value: Variant; Args: TArguments);
begin
  TFieldDefs(Args.Obj).Update;
end;

{ property Read Count: Integer }
procedure TFieldDefs_Read_Count(var Value: Variant; Args: TArguments);
begin
  Value := TFieldDefs(Args.Obj).Count;
end;

{ property Read Items[Integer]: TFieldDef }
procedure TFieldDefs_Read_Items(var Value: Variant; Args: TArguments);
begin
  Value := O2V(TFieldDefs(Args.Obj).Items[Args.Values[0]]);
end;

  { TField }

{ constructor Create(AOwner: TComponent) }
procedure TField_Create(var Value: Variant; Args: TArguments);
begin
  Value := O2V(TField.Create(V2O(Args.Values[0]) as TComponent));
end;

{  procedure Assign(Source: TPersistent); }
procedure TField_Assign(var Value: Variant; Args: TArguments);
begin
  TField(Args.Obj).Assign(V2O(Args.Values[0]) as TPersistent);
end;

(*
{  procedure AssignValue(const Value: TVarRec); }
procedure TField_AssignValue(var Value: Variant; Args: TArguments);
begin
  TField(Args.Obj).AssignValue(Args.Values[0]);
end;
*)

{  procedure Clear; }
procedure TField_Clear(var Value: Variant; Args: TArguments);
begin
  TField(Args.Obj).Clear;
end;

{  procedure FocusControl; }
procedure TField_FocusControl(var Value: Variant; Args: TArguments);
begin
  TField(Args.Obj).FocusControl;
end;

{  function GetData(Buffer: Pointer): Boolean; }
procedure TField_GetData(var Value: Variant; Args: TArguments);
begin
  Value := TField(Args.Obj).GetData(V2P(Args.Values[0]));
end;

{  function IsBlob: Boolean; }
procedure TField_IsBlob(var Value: Variant; Args: TArguments);
begin
  Value := TField(Args.Obj).IsBlob;
end;

{  function IsValidChar(InputChar: Char): Boolean; }
procedure TField_IsValidChar(var Value: Variant; Args: TArguments);
begin
  Value := TField(Args.Obj).IsValidChar(string(Args.Values[0])[1]);
end;

{  procedure RefreshLookupList; }
procedure TField_RefreshLookupList(var Value: Variant; Args: TArguments);
begin
  TField(Args.Obj).RefreshLookupList;
end;

{  procedure SetData(Buffer: Pointer); }
procedure TField_SetData(var Value: Variant; Args: TArguments);
begin
  TField(Args.Obj).SetData(V2P(Args.Values[0]));
end;

{  procedure SetFieldType(Value: TFieldType); }
procedure TField_SetFieldType(var Value: Variant; Args: TArguments);
begin
  TField(Args.Obj).SetFieldType(Args.Values[0]);
end;

{  procedure Validate(Buffer: Pointer); }
procedure TField_Validate(var Value: Variant; Args: TArguments);
begin
  TField(Args.Obj).Validate(V2P(Args.Values[0]));
end;

{ property Read AsBoolean: Boolean }
procedure TField_Read_AsBoolean(var Value: Variant; Args: TArguments);
begin
  Value := TField(Args.Obj).AsBoolean;
end;

{ property Write AsBoolean(Value: Boolean) }
procedure TField_Write_AsBoolean(const Value: Variant; Args: TArguments);
begin
  TField(Args.Obj).AsBoolean := Value;
end;

{ property Read AsCurrency: Currency }
procedure TField_Read_AsCurrency(var Value: Variant; Args: TArguments);
begin
  Value := TField(Args.Obj).AsCurrency;
end;

{ property Write AsCurrency(Value: Currency) }
procedure TField_Write_AsCurrency(const Value: Variant; Args: TArguments);
begin
  TField(Args.Obj).AsCurrency := Value;
end;

{ property Read AsDateTime: TDateTime }
procedure TField_Read_AsDateTime(var Value: Variant; Args: TArguments);
begin
  Value := TField(Args.Obj).AsDateTime;
end;

{ property Write AsDateTime(Value: TDateTime) }
procedure TField_Write_AsDateTime(const Value: Variant; Args: TArguments);
begin
  TField(Args.Obj).AsDateTime := Value;
end;

{ property Read AsFloat: Double }
procedure TField_Read_AsFloat(var Value: Variant; Args: TArguments);
begin
  Value := TField(Args.Obj).AsFloat;
end;

{ property Write AsFloat(Value: Double) }
procedure TField_Write_AsFloat(const Value: Variant; Args: TArguments);
begin
  TField(Args.Obj).AsFloat := Value;
end;

{ property Read AsInteger: Longint }
procedure TField_Read_AsInteger(var Value: Variant; Args: TArguments);
begin
  Value := TField(Args.Obj).AsInteger;
end;

{ property Write AsInteger(Value: Longint) }
procedure TField_Write_AsInteger(const Value: Variant; Args: TArguments);
begin
  TField(Args.Obj).AsInteger := Value;
end;

{ property Read AsString: string }
procedure TField_Read_AsString(var Value: Variant; Args: TArguments);
begin
  Value := TField(Args.Obj).AsString;
end;

{ property Write AsString(Value: string) }
procedure TField_Write_AsString(const Value: Variant; Args: TArguments);
begin
  TField(Args.Obj).AsString := Value;
end;

{ property Read AsVariant: Variant }
procedure TField_Read_AsVariant(var Value: Variant; Args: TArguments);
begin
  Value := TField(Args.Obj).AsVariant;
end;

{ property Write AsVariant(Value: Variant) }
procedure TField_Write_AsVariant(const Value: Variant; Args: TArguments);
begin
  TField(Args.Obj).AsVariant := Value;
end;

{ property Read AttributeSet: string }
procedure TField_Read_AttributeSet(var Value: Variant; Args: TArguments);
begin
  Value := TField(Args.Obj).AttributeSet;
end;

{ property Write AttributeSet(Value: string) }
procedure TField_Write_AttributeSet(const Value: Variant; Args: TArguments);
begin
  TField(Args.Obj).AttributeSet := Value;
end;

{ property Read Calculated: Boolean }
procedure TField_Read_Calculated(var Value: Variant; Args: TArguments);
begin
  Value := TField(Args.Obj).Calculated;
end;

{ property Write Calculated(Value: Boolean) }
procedure TField_Write_Calculated(const Value: Variant; Args: TArguments);
begin
  TField(Args.Obj).Calculated := Value;
end;

{ property Read CanModify: Boolean }
procedure TField_Read_CanModify(var Value: Variant; Args: TArguments);
begin
  Value := TField(Args.Obj).CanModify;
end;

{ property Read CurValue: Variant }
procedure TField_Read_CurValue(var Value: Variant; Args: TArguments);
begin
  Value := TField(Args.Obj).CurValue;
end;

{ property Read DataSet: TDataSet }
procedure TField_Read_DataSet(var Value: Variant; Args: TArguments);
begin
  Value := O2V(TField(Args.Obj).DataSet);
end;

{ property Write DataSet(Value: TDataSet) }
procedure TField_Write_DataSet(const Value: Variant; Args: TArguments);
begin
  TField(Args.Obj).DataSet := V2O(Value) as TDataSet;
end;

{ property Read DataSize: Word }
procedure TField_Read_DataSize(var Value: Variant; Args: TArguments);
begin
  Value := TField(Args.Obj).DataSize;
end;

{ property Read DataType: TFieldType }
procedure TField_Read_DataType(var Value: Variant; Args: TArguments);
begin
  Value := TField(Args.Obj).DataType;
end;

{ property Read DisplayName: string }
procedure TField_Read_DisplayName(var Value: Variant; Args: TArguments);
begin
  Value := TField(Args.Obj).DisplayName;
end;

{ property Read DisplayText: string }
procedure TField_Read_DisplayText(var Value: Variant; Args: TArguments);
begin
  Value := TField(Args.Obj).DisplayText;
end;

{ property Read EditMask: string }
procedure TField_Read_EditMask(var Value: Variant; Args: TArguments);
begin
  Value := TField(Args.Obj).EditMask;
end;

{ property Write EditMask(Value: string) }
procedure TField_Write_EditMask(const Value: Variant; Args: TArguments);
begin
  TField(Args.Obj).EditMask := Value;
end;

{ property Read EditMaskPtr: string }
procedure TField_Read_EditMaskPtr(var Value: Variant; Args: TArguments);
begin
  Value := TField(Args.Obj).EditMaskPtr;
end;

{ property Read FieldNo: Integer }
procedure TField_Read_FieldNo(var Value: Variant; Args: TArguments);
begin
  Value := TField(Args.Obj).FieldNo;
end;

{ property Read IsIndexField: Boolean }
procedure TField_Read_IsIndexField(var Value: Variant; Args: TArguments);
begin
  Value := TField(Args.Obj).IsIndexField;
end;

{ property Read IsNull: Boolean }
procedure TField_Read_IsNull(var Value: Variant; Args: TArguments);
begin
  Value := TField(Args.Obj).IsNull;
end;

{ property Read Lookup: Boolean }
procedure TField_Read_Lookup(var Value: Variant; Args: TArguments);
begin
  Value := TField(Args.Obj).Lookup;
end;

{ property Write Lookup(Value: Boolean) }
procedure TField_Write_Lookup(const Value: Variant; Args: TArguments);
begin
  TField(Args.Obj).Lookup := Value;
end;

{ property Read NewValue: Variant }
procedure TField_Read_NewValue(var Value: Variant; Args: TArguments);
begin
  Value := TField(Args.Obj).NewValue;
end;

{ property Write NewValue(Value: Variant) }
procedure TField_Write_NewValue(const Value: Variant; Args: TArguments);
begin
  TField(Args.Obj).NewValue := Value;
end;

{ property Read Offset: word }
procedure TField_Read_Offset(var Value: Variant; Args: TArguments);
begin
  Value := TField(Args.Obj).Offset;
end;

{ property Read OldValue: Variant }
procedure TField_Read_OldValue(var Value: Variant; Args: TArguments);
begin
  Value := TField(Args.Obj).OldValue;
end;

{ property Read Size: Word }
procedure TField_Read_Size(var Value: Variant; Args: TArguments);
begin
  Value := TField(Args.Obj).Size;
end;

{ property Write Size(Value: Word) }
procedure TField_Write_Size(const Value: Variant; Args: TArguments);
begin
  TField(Args.Obj).Size := Value;
end;

{ property Read Text: string }
procedure TField_Read_Text(var Value: Variant; Args: TArguments);
begin
  Value := TField(Args.Obj).Text;
end;

{ property Write Text(Value: string) }
procedure TField_Write_Text(const Value: Variant; Args: TArguments);
begin
  TField(Args.Obj).Text := Value;
end;

(*
{ property Read ValidChars: TFieldChars }
procedure TField_Read_ValidChars(var Value: Variant; Args: TArguments);
begin
  Value := TField(Args.Obj).ValidChars;
end;

{ property Write ValidChars(Value: TFieldChars) }
procedure TField_Write_ValidChars(const Value: Variant; Args: TArguments);
begin
  TField(Args.Obj).ValidChars := Value;
end;
*)

{ property Read Value: Variant }
procedure TField_Read_Value(var Value: Variant; Args: TArguments);
begin
  Value := TField(Args.Obj).Value;
end;

{ property Write Value(Value: Variant) }
procedure TField_Write_Value(const Value: Variant; Args: TArguments);
begin
  TField(Args.Obj).Value := Value;
end;

{ property Read Alignment: TAlignment }
procedure TField_Read_Alignment(var Value: Variant; Args: TArguments);
begin
  Value := TField(Args.Obj).Alignment;
end;

{ property Write Alignment(Value: TAlignment) }
procedure TField_Write_Alignment(const Value: Variant; Args: TArguments);
begin
  TField(Args.Obj).Alignment := Value;
end;

{ property Read CustomConstraint: string }
procedure TField_Read_CustomConstraint(var Value: Variant; Args: TArguments);
begin
  Value := TField(Args.Obj).CustomConstraint;
end;

{ property Write CustomConstraint(Value: string) }
procedure TField_Write_CustomConstraint(const Value: Variant; Args: TArguments);
begin
  TField(Args.Obj).CustomConstraint := Value;
end;

{ property Read ConstraintErrorMessage: string }
procedure TField_Read_ConstraintErrorMessage(var Value: Variant; Args: TArguments);
begin
  Value := TField(Args.Obj).ConstraintErrorMessage;
end;

{ property Write ConstraintErrorMessage(Value: string) }
procedure TField_Write_ConstraintErrorMessage(const Value: Variant; Args: TArguments);
begin
  TField(Args.Obj).ConstraintErrorMessage := Value;
end;

{ property Read DefaultExpression: string }
procedure TField_Read_DefaultExpression(var Value: Variant; Args: TArguments);
begin
  Value := TField(Args.Obj).DefaultExpression;
end;

{ property Write DefaultExpression(Value: string) }
procedure TField_Write_DefaultExpression(const Value: Variant; Args: TArguments);
begin
  TField(Args.Obj).DefaultExpression := Value;
end;

{ property Read DisplayLabel: string }
procedure TField_Read_DisplayLabel(var Value: Variant; Args: TArguments);
begin
  Value := TField(Args.Obj).DisplayLabel;
end;

{ property Write DisplayLabel(Value: string) }
procedure TField_Write_DisplayLabel(const Value: Variant; Args: TArguments);
begin
  TField(Args.Obj).DisplayLabel := Value;
end;

{ property Read DisplayWidth: Integer }
procedure TField_Read_DisplayWidth(var Value: Variant; Args: TArguments);
begin
  Value := TField(Args.Obj).DisplayWidth;
end;

{ property Write DisplayWidth(Value: Integer) }
procedure TField_Write_DisplayWidth(const Value: Variant; Args: TArguments);
begin
  TField(Args.Obj).DisplayWidth := Value;
end;

{ property Read FieldKind: TFieldKind }
procedure TField_Read_FieldKind(var Value: Variant; Args: TArguments);
begin
  Value := TField(Args.Obj).FieldKind;
end;

{ property Write FieldKind(Value: TFieldKind) }
procedure TField_Write_FieldKind(const Value: Variant; Args: TArguments);
begin
  TField(Args.Obj).FieldKind := Value;
end;

{ property Read FieldName: string }
procedure TField_Read_FieldName(var Value: Variant; Args: TArguments);
begin
  Value := TField(Args.Obj).FieldName;
end;

{ property Write FieldName(Value: string) }
procedure TField_Write_FieldName(const Value: Variant; Args: TArguments);
begin
  TField(Args.Obj).FieldName := Value;
end;

{ property Read HasConstraints: Boolean }
procedure TField_Read_HasConstraints(var Value: Variant; Args: TArguments);
begin
  Value := TField(Args.Obj).HasConstraints;
end;

{ property Read Index: Integer }
procedure TField_Read_Index(var Value: Variant; Args: TArguments);
begin
  Value := TField(Args.Obj).Index;
end;

{ property Write Index(Value: Integer) }
procedure TField_Write_Index(const Value: Variant; Args: TArguments);
begin
  TField(Args.Obj).Index := Value;
end;

{ property Read ImportedConstraint: string }
procedure TField_Read_ImportedConstraint(var Value: Variant; Args: TArguments);
begin
  Value := TField(Args.Obj).ImportedConstraint;
end;

{ property Write ImportedConstraint(Value: string) }
procedure TField_Write_ImportedConstraint(const Value: Variant; Args: TArguments);
begin
  TField(Args.Obj).ImportedConstraint := Value;
end;

{ property Read LookupDataSet: TDataSet }
procedure TField_Read_LookupDataSet(var Value: Variant; Args: TArguments);
begin
  Value := O2V(TField(Args.Obj).LookupDataSet);
end;

{ property Write LookupDataSet(Value: TDataSet) }
procedure TField_Write_LookupDataSet(const Value: Variant; Args: TArguments);
begin
  TField(Args.Obj).LookupDataSet := V2O(Value) as TDataSet;
end;

{ property Read LookupKeyFields: string }
procedure TField_Read_LookupKeyFields(var Value: Variant; Args: TArguments);
begin
  Value := TField(Args.Obj).LookupKeyFields;
end;

{ property Write LookupKeyFields(Value: string) }
procedure TField_Write_LookupKeyFields(const Value: Variant; Args: TArguments);
begin
  TField(Args.Obj).LookupKeyFields := Value;
end;

{ property Read LookupResultField: string }
procedure TField_Read_LookupResultField(var Value: Variant; Args: TArguments);
begin
  Value := TField(Args.Obj).LookupResultField;
end;

{ property Write LookupResultField(Value: string) }
procedure TField_Write_LookupResultField(const Value: Variant; Args: TArguments);
begin
  TField(Args.Obj).LookupResultField := Value;
end;

{ property Read KeyFields: string }
procedure TField_Read_KeyFields(var Value: Variant; Args: TArguments);
begin
  Value := TField(Args.Obj).KeyFields;
end;

{ property Write KeyFields(Value: string) }
procedure TField_Write_KeyFields(const Value: Variant; Args: TArguments);
begin
  TField(Args.Obj).KeyFields := Value;
end;

{ property Read LookupCache: Boolean }
procedure TField_Read_LookupCache(var Value: Variant; Args: TArguments);
begin
  Value := TField(Args.Obj).LookupCache;
end;

{ property Write LookupCache(Value: Boolean) }
procedure TField_Write_LookupCache(const Value: Variant; Args: TArguments);
begin
  TField(Args.Obj).LookupCache := Value;
end;

{ property Read Origin: string }
procedure TField_Read_Origin(var Value: Variant; Args: TArguments);
begin
  Value := TField(Args.Obj).Origin;
end;

{ property Write Origin(Value: string) }
procedure TField_Write_Origin(const Value: Variant; Args: TArguments);
begin
  TField(Args.Obj).Origin := Value;
end;

{ property Read ReadOnly: Boolean }
procedure TField_Read_ReadOnly(var Value: Variant; Args: TArguments);
begin
  Value := TField(Args.Obj).ReadOnly;
end;

{ property Write ReadOnly(Value: Boolean) }
procedure TField_Write_ReadOnly(const Value: Variant; Args: TArguments);
begin
  TField(Args.Obj).ReadOnly := Value;
end;

{ property Read Required: Boolean }
procedure TField_Read_Required(var Value: Variant; Args: TArguments);
begin
  Value := TField(Args.Obj).Required;
end;

{ property Write Required(Value: Boolean) }
procedure TField_Write_Required(const Value: Variant; Args: TArguments);
begin
  TField(Args.Obj).Required := Value;
end;

{ property Read Visible: Boolean }
procedure TField_Read_Visible(var Value: Variant; Args: TArguments);
begin
  Value := TField(Args.Obj).Visible;
end;

{ property Write Visible(Value: Boolean) }
procedure TField_Write_Visible(const Value: Variant; Args: TArguments);
begin
  TField(Args.Obj).Visible := Value;
end;

  { TStringField }

{ constructor Create(AOwner: TComponent) }
procedure TStringField_Create(var Value: Variant; Args: TArguments);
begin
  Value := O2V(TStringField.Create(V2O(Args.Values[0]) as TComponent));
end;

{ property Read Value: string }
procedure TStringField_Read_Value(var Value: Variant; Args: TArguments);
begin
  Value := TStringField(Args.Obj).Value;
end;

{ property Write Value(Value: string) }
procedure TStringField_Write_Value(const Value: Variant; Args: TArguments);
begin
  TStringField(Args.Obj).Value := Value;
end;

{ property Read Transliterate: Boolean }
procedure TStringField_Read_Transliterate(var Value: Variant; Args: TArguments);
begin
  Value := TStringField(Args.Obj).Transliterate;
end;

{ property Write Transliterate(Value: Boolean) }
procedure TStringField_Write_Transliterate(const Value: Variant; Args: TArguments);
begin
  TStringField(Args.Obj).Transliterate := Value;
end;

  { TNumericField }

{ constructor Create(AOwner: TComponent) }
procedure TNumericField_Create(var Value: Variant; Args: TArguments);
begin
  Value := O2V(TNumericField.Create(V2O(Args.Values[0]) as TComponent));
end;

{ property Read DisplayFormat: string }
procedure TNumericField_Read_DisplayFormat(var Value: Variant; Args: TArguments);
begin
  Value := TNumericField(Args.Obj).DisplayFormat;
end;

{ property Write DisplayFormat(Value: string) }
procedure TNumericField_Write_DisplayFormat(const Value: Variant; Args: TArguments);
begin
  TNumericField(Args.Obj).DisplayFormat := Value;
end;

{ property Read EditFormat: string }
procedure TNumericField_Read_EditFormat(var Value: Variant; Args: TArguments);
begin
  Value := TNumericField(Args.Obj).EditFormat;
end;

{ property Write EditFormat(Value: string) }
procedure TNumericField_Write_EditFormat(const Value: Variant; Args: TArguments);
begin
  TNumericField(Args.Obj).EditFormat := Value;
end;

  { TIntegerField }

{ constructor Create(AOwner: TComponent) }
procedure TIntegerField_Create(var Value: Variant; Args: TArguments);
begin
  Value := O2V(TIntegerField.Create(V2O(Args.Values[0]) as TComponent));
end;

{ property Read Value: Longint }
procedure TIntegerField_Read_Value(var Value: Variant; Args: TArguments);
begin
  Value := TIntegerField(Args.Obj).Value;
end;

{ property Write Value(Value: Longint) }
procedure TIntegerField_Write_Value(const Value: Variant; Args: TArguments);
begin
  TIntegerField(Args.Obj).Value := Value;
end;

{ property Read MaxValue: Longint }
procedure TIntegerField_Read_MaxValue(var Value: Variant; Args: TArguments);
begin
  Value := TIntegerField(Args.Obj).MaxValue;
end;

{ property Write MaxValue(Value: Longint) }
procedure TIntegerField_Write_MaxValue(const Value: Variant; Args: TArguments);
begin
  TIntegerField(Args.Obj).MaxValue := Value;
end;

{ property Read MinValue: Longint }
procedure TIntegerField_Read_MinValue(var Value: Variant; Args: TArguments);
begin
  Value := TIntegerField(Args.Obj).MinValue;
end;

{ property Write MinValue(Value: Longint) }
procedure TIntegerField_Write_MinValue(const Value: Variant; Args: TArguments);
begin
  TIntegerField(Args.Obj).MinValue := Value;
end;

  { TSmallintField }

{ constructor Create(AOwner: TComponent) }
procedure TSmallintField_Create(var Value: Variant; Args: TArguments);
begin
  Value := O2V(TSmallintField.Create(V2O(Args.Values[0]) as TComponent));
end;

  { TWordField }

{ constructor Create(AOwner: TComponent) }
procedure TWordField_Create(var Value: Variant; Args: TArguments);
begin
  Value := O2V(TWordField.Create(V2O(Args.Values[0]) as TComponent));
end;

  { TAutoIncField }

{ constructor Create(AOwner: TComponent) }
procedure TAutoIncField_Create(var Value: Variant; Args: TArguments);
begin
  Value := O2V(TAutoIncField.Create(V2O(Args.Values[0]) as TComponent));
end;

  { TFloatField }

{ constructor Create(AOwner: TComponent) }
procedure TFloatField_Create(var Value: Variant; Args: TArguments);
begin
  Value := O2V(TFloatField.Create(V2O(Args.Values[0]) as TComponent));
end;

{ property Read Value: Double }
procedure TFloatField_Read_Value(var Value: Variant; Args: TArguments);
begin
  Value := TFloatField(Args.Obj).Value;
end;

{ property Write Value(Value: Double) }
procedure TFloatField_Write_Value(const Value: Variant; Args: TArguments);
begin
  TFloatField(Args.Obj).Value := Value;
end;

{ property Read Currency: Boolean }
procedure TFloatField_Read_Currency(var Value: Variant; Args: TArguments);
begin
  Value := TFloatField(Args.Obj).Currency;
end;

{ property Write Currency(Value: Boolean) }
procedure TFloatField_Write_Currency(const Value: Variant; Args: TArguments);
begin
  TFloatField(Args.Obj).Currency := Value;
end;

{ property Read MaxValue: Double }
procedure TFloatField_Read_MaxValue(var Value: Variant; Args: TArguments);
begin
  Value := TFloatField(Args.Obj).MaxValue;
end;

{ property Write MaxValue(Value: Double) }
procedure TFloatField_Write_MaxValue(const Value: Variant; Args: TArguments);
begin
  TFloatField(Args.Obj).MaxValue := Value;
end;

{ property Read MinValue: Double }
procedure TFloatField_Read_MinValue(var Value: Variant; Args: TArguments);
begin
  Value := TFloatField(Args.Obj).MinValue;
end;

{ property Write MinValue(Value: Double) }
procedure TFloatField_Write_MinValue(const Value: Variant; Args: TArguments);
begin
  TFloatField(Args.Obj).MinValue := Value;
end;

{ property Read Precision: Integer }
procedure TFloatField_Read_Precision(var Value: Variant; Args: TArguments);
begin
  Value := TFloatField(Args.Obj).Precision;
end;

{ property Write Precision(Value: Integer) }
procedure TFloatField_Write_Precision(const Value: Variant; Args: TArguments);
begin
  TFloatField(Args.Obj).Precision := Value;
end;

  { TCurrencyField }

{ constructor Create(AOwner: TComponent) }
procedure TCurrencyField_Create(var Value: Variant; Args: TArguments);
begin
  Value := O2V(TCurrencyField.Create(V2O(Args.Values[0]) as TComponent));
end;

  { TBooleanField }

{ constructor Create(AOwner: TComponent) }
procedure TBooleanField_Create(var Value: Variant; Args: TArguments);
begin
  Value := O2V(TBooleanField.Create(V2O(Args.Values[0]) as TComponent));
end;

{ property Read Value: Boolean }
procedure TBooleanField_Read_Value(var Value: Variant; Args: TArguments);
begin
  Value := TBooleanField(Args.Obj).Value;
end;

{ property Write Value(Value: Boolean) }
procedure TBooleanField_Write_Value(const Value: Variant; Args: TArguments);
begin
  TBooleanField(Args.Obj).Value := Value;
end;

{ property Read DisplayValues: string }
procedure TBooleanField_Read_DisplayValues(var Value: Variant; Args: TArguments);
begin
  Value := TBooleanField(Args.Obj).DisplayValues;
end;

{ property Write DisplayValues(Value: string) }
procedure TBooleanField_Write_DisplayValues(const Value: Variant; Args: TArguments);
begin
  TBooleanField(Args.Obj).DisplayValues := Value;
end;

  { TDateTimeField }

{ constructor Create(AOwner: TComponent) }
procedure TDateTimeField_Create(var Value: Variant; Args: TArguments);
begin
  Value := O2V(TDateTimeField.Create(V2O(Args.Values[0]) as TComponent));
end;

{ property Read Value: TDateTime }
procedure TDateTimeField_Read_Value(var Value: Variant; Args: TArguments);
begin
  Value := TDateTimeField(Args.Obj).Value;
end;

{ property Write Value(Value: TDateTime) }
procedure TDateTimeField_Write_Value(const Value: Variant; Args: TArguments);
begin
  TDateTimeField(Args.Obj).Value := Value;
end;

{ property Read DisplayFormat: string }
procedure TDateTimeField_Read_DisplayFormat(var Value: Variant; Args: TArguments);
begin
  Value := TDateTimeField(Args.Obj).DisplayFormat;
end;

{ property Write DisplayFormat(Value: string) }
procedure TDateTimeField_Write_DisplayFormat(const Value: Variant; Args: TArguments);
begin
  TDateTimeField(Args.Obj).DisplayFormat := Value;
end;

  { TDateField }

{ constructor Create(AOwner: TComponent) }
procedure TDateField_Create(var Value: Variant; Args: TArguments);
begin
  Value := O2V(TDateField.Create(V2O(Args.Values[0]) as TComponent));
end;

  { TTimeField }

{ constructor Create(AOwner: TComponent) }
procedure TTimeField_Create(var Value: Variant; Args: TArguments);
begin
  Value := O2V(TTimeField.Create(V2O(Args.Values[0]) as TComponent));
end;

  { TBinaryField }

{ constructor Create(AOwner: TComponent) }
procedure TBinaryField_Create(var Value: Variant; Args: TArguments);
begin
  Value := O2V(TBinaryField.Create(V2O(Args.Values[0]) as TComponent));
end;

  { TBytesField }

{ constructor Create(AOwner: TComponent) }
procedure TBytesField_Create(var Value: Variant; Args: TArguments);
begin
  Value := O2V(TBytesField.Create(V2O(Args.Values[0]) as TComponent));
end;

  { TVarBytesField }

{ constructor Create(AOwner: TComponent) }
procedure TVarBytesField_Create(var Value: Variant; Args: TArguments);
begin
  Value := O2V(TVarBytesField.Create(V2O(Args.Values[0]) as TComponent));
end;

  { TBCDField }

{ constructor Create(AOwner: TComponent) }
procedure TBCDField_Create(var Value: Variant; Args: TArguments);
begin
  Value := O2V(TBCDField.Create(V2O(Args.Values[0]) as TComponent));
end;

{ property Read Value: Currency }
procedure TBCDField_Read_Value(var Value: Variant; Args: TArguments);
begin
  Value := TBCDField(Args.Obj).Value;
end;

{ property Write Value(Value: Currency) }
procedure TBCDField_Write_Value(const Value: Variant; Args: TArguments);
begin
  TBCDField(Args.Obj).Value := Value;
end;

{ property Read Currency: Boolean }
procedure TBCDField_Read_Currency(var Value: Variant; Args: TArguments);
begin
  Value := TBCDField(Args.Obj).Currency;
end;

{ property Write Currency(Value: Boolean) }
procedure TBCDField_Write_Currency(const Value: Variant; Args: TArguments);
begin
  TBCDField(Args.Obj).Currency := Value;
end;

{ property Read MaxValue: Currency }
procedure TBCDField_Read_MaxValue(var Value: Variant; Args: TArguments);
begin
  Value := TBCDField(Args.Obj).MaxValue;
end;

{ property Write MaxValue(Value: Currency) }
procedure TBCDField_Write_MaxValue(const Value: Variant; Args: TArguments);
begin
  TBCDField(Args.Obj).MaxValue := Value;
end;

{ property Read MinValue: Currency }
procedure TBCDField_Read_MinValue(var Value: Variant; Args: TArguments);
begin
  Value := TBCDField(Args.Obj).MinValue;
end;

{ property Write MinValue(Value: Currency) }
procedure TBCDField_Write_MinValue(const Value: Variant; Args: TArguments);
begin
  TBCDField(Args.Obj).MinValue := Value;
end;

  { TBlobField }

{ constructor Create(AOwner: TComponent) }
procedure TBlobField_Create(var Value: Variant; Args: TArguments);
begin
  Value := O2V(TBlobField.Create(V2O(Args.Values[0]) as TComponent));
end;

{  procedure Assign(Source: TPersistent); }
procedure TBlobField_Assign(var Value: Variant; Args: TArguments);
begin
  TBlobField(Args.Obj).Assign(V2O(Args.Values[0]) as TPersistent);
end;

{  procedure Clear; }
procedure TBlobField_Clear(var Value: Variant; Args: TArguments);
begin
  TBlobField(Args.Obj).Clear;
end;


{  function IsBlob: Boolean; }
procedure TBlobField_IsBlob(var Value: Variant; Args: TArguments);
begin
  Value := TBlobField(Args.Obj).IsBlob;
end;

{  procedure LoadFromFile(const FileName: string); }
procedure TBlobField_LoadFromFile(var Value: Variant; Args: TArguments);
begin
  TBlobField(Args.Obj).LoadFromFile(Args.Values[0]);
end;

{  procedure LoadFromStream(Stream: TStream); }
procedure TBlobField_LoadFromStream(var Value: Variant; Args: TArguments);
begin
  TBlobField(Args.Obj).LoadFromStream(V2O(Args.Values[0]) as TStream);
end;

{  procedure SaveToFile(const FileName: string); }
procedure TBlobField_SaveToFile(var Value: Variant; Args: TArguments);
begin
  TBlobField(Args.Obj).SaveToFile(Args.Values[0]);
end;

{  procedure SaveToStream(Stream: TStream); }
procedure TBlobField_SaveToStream(var Value: Variant; Args: TArguments);
begin
  TBlobField(Args.Obj).SaveToStream(V2O(Args.Values[0]) as TStream);
end;

{  procedure SetFieldType(Value: TFieldType); }
procedure TBlobField_SetFieldType(var Value: Variant; Args: TArguments);
begin
  TBlobField(Args.Obj).SetFieldType(Args.Values[0]);
end;

{ property Read BlobSize: Integer }
procedure TBlobField_Read_BlobSize(var Value: Variant; Args: TArguments);
begin
  Value := TBlobField(Args.Obj).BlobSize;
end;

{ property Read Modified: Boolean }
procedure TBlobField_Read_Modified(var Value: Variant; Args: TArguments);
begin
  Value := TBlobField(Args.Obj).Modified;
end;

{ property Write Modified(Value: Boolean) }
procedure TBlobField_Write_Modified(const Value: Variant; Args: TArguments);
begin
  TBlobField(Args.Obj).Modified := Value;
end;

{ property Read Value: string }
procedure TBlobField_Read_Value(var Value: Variant; Args: TArguments);
begin
  Value := TBlobField(Args.Obj).Value;
end;

{ property Write Value(Value: string) }
procedure TBlobField_Write_Value(const Value: Variant; Args: TArguments);
begin
  TBlobField(Args.Obj).Value := Value;
end;

{ property Read Transliterate: Boolean }
procedure TBlobField_Read_Transliterate(var Value: Variant; Args: TArguments);
begin
  Value := TBlobField(Args.Obj).Transliterate;
end;

{ property Write Transliterate(Value: Boolean) }
procedure TBlobField_Write_Transliterate(const Value: Variant; Args: TArguments);
begin
  TBlobField(Args.Obj).Transliterate := Value;
end;

{ property Read BlobType: TBlobType }
procedure TBlobField_Read_BlobType(var Value: Variant; Args: TArguments);
begin
  Value := TBlobField(Args.Obj).BlobType;
end;

{ property Write BlobType(Value: TBlobType) }
procedure TBlobField_Write_BlobType(const Value: Variant; Args: TArguments);
begin
  TBlobField(Args.Obj).BlobType := Value;
end;

  { TMemoField }

{ constructor Create(AOwner: TComponent) }
procedure TMemoField_Create(var Value: Variant; Args: TArguments);
begin
  Value := O2V(TMemoField.Create(V2O(Args.Values[0]) as TComponent));
end;

  { TGraphicField }

{ constructor Create(AOwner: TComponent) }
procedure TGraphicField_Create(var Value: Variant; Args: TArguments);
begin
  Value := O2V(TGraphicField.Create(V2O(Args.Values[0]) as TComponent));
end;

  { TIndexDef }

{ constructor Create(Owner: TIndexDefs; Name: string; Fields: string; Options: TIndexOptions) }
procedure TIndexDef_Create(var Value: Variant; Args: TArguments);
begin
  Value := O2V(TIndexDef.Create(V2O(Args.Values[0]) as TIndexDefs, string(Args.Values[1]), string(Args.Values[2]), TIndexOptions(Byte(V2S(Args.Values[3])))));
end;

{ property Read Expression: string }
procedure TIndexDef_Read_Expression(var Value: Variant; Args: TArguments);
begin
  Value := TIndexDef(Args.Obj).Expression;
end;

{ property Read Fields: string }
procedure TIndexDef_Read_Fields(var Value: Variant; Args: TArguments);
begin
  Value := TIndexDef(Args.Obj).Fields;
end;

{ property Read Name: string }
procedure TIndexDef_Read_Name(var Value: Variant; Args: TArguments);
begin
  Value := TIndexDef(Args.Obj).Name;
end;

{ property Read Options: TIndexOptions }
procedure TIndexDef_Read_Options(var Value: Variant; Args: TArguments);
begin
  Value := S2V(Byte(TIndexDef(Args.Obj).Options));
end;

{ property Read Source: string }
procedure TIndexDef_Read_Source(var Value: Variant; Args: TArguments);
begin
  Value := TIndexDef(Args.Obj).Source;
end;

{ property Write Source(Value: string) }
procedure TIndexDef_Write_Source(const Value: Variant; Args: TArguments);
begin
  TIndexDef(Args.Obj).Source := Value;
end;

  { TIndexDefs }

{ constructor Create(DataSet: TDataSet) }
procedure TIndexDefs_Create(var Value: Variant; Args: TArguments);
begin
  Value := O2V(TIndexDefs.Create(V2O(Args.Values[0]) as TDataSet));
end;

{  procedure Add(const Name, Fields: string; Options: TIndexOptions); }
procedure TIndexDefs_Add(var Value: Variant; Args: TArguments);
begin
  TIndexDefs(Args.Obj).Add(Args.Values[0], Args.Values[1], TIndexOptions(Byte(V2S(Args.Values[2]))));
end;

{  procedure Assign(IndexDefs: TIndexDefs); }
procedure TIndexDefs_Assign(var Value: Variant; Args: TArguments);
begin
  TIndexDefs(Args.Obj).Assign(V2O(Args.Values[0]) as TIndexDefs);
end;

{  procedure Clear; }
procedure TIndexDefs_Clear(var Value: Variant; Args: TArguments);
begin
  TIndexDefs(Args.Obj).Clear;
end;

{  function FindIndexForFields(const Fields: string): TIndexDef; }
procedure TIndexDefs_FindIndexForFields(var Value: Variant; Args: TArguments);
begin
  Value := O2V(TIndexDefs(Args.Obj).FindIndexForFields(Args.Values[0]));
end;

{  function GetIndexForFields(const Fields: string; CaseInsensitive: Boolean): TIndexDef; }
procedure TIndexDefs_GetIndexForFields(var Value: Variant; Args: TArguments);
begin
  Value := O2V(TIndexDefs(Args.Obj).GetIndexForFields(Args.Values[0], Args.Values[1]));
end;

{  function IndexOf(const Name: string): Integer; }
procedure TIndexDefs_IndexOf(var Value: Variant; Args: TArguments);
begin
  Value := TIndexDefs(Args.Obj).IndexOf(Args.Values[0]);
end;

{  procedure Update; }
procedure TIndexDefs_Update(var Value: Variant; Args: TArguments);
begin
  TIndexDefs(Args.Obj).Update;
end;

{ property Read Count: Integer }
procedure TIndexDefs_Read_Count(var Value: Variant; Args: TArguments);
begin
  Value := TIndexDefs(Args.Obj).Count;
end;

{ property Read Items[Integer]: TIndexDef }
procedure TIndexDefs_Read_Items(var Value: Variant; Args: TArguments);
begin
  Value := O2V(TIndexDefs(Args.Obj).Items[Args.Values[0]]);
end;

{ property Read Updated: Boolean }
procedure TIndexDefs_Read_Updated(var Value: Variant; Args: TArguments);
begin
  Value := TIndexDefs(Args.Obj).Updated;
end;

{ property Write Updated(Value: Boolean) }
procedure TIndexDefs_Write_Updated(const Value: Variant; Args: TArguments);
begin
  TIndexDefs(Args.Obj).Updated := Value;
end;

  { TDataLink }

{ constructor Create }
procedure TDataLink_Create(var Value: Variant; Args: TArguments);
begin
  Value := O2V(TDataLink.Create);
end;

{  function Edit: Boolean; }
procedure TDataLink_Edit(var Value: Variant; Args: TArguments);
begin
  Value := TDataLink(Args.Obj).Edit;
end;

{  procedure UpdateRecord; }
procedure TDataLink_UpdateRecord(var Value: Variant; Args: TArguments);
begin
  TDataLink(Args.Obj).UpdateRecord;
end;

{ property Read Active: Boolean }
procedure TDataLink_Read_Active(var Value: Variant; Args: TArguments);
begin
  Value := TDataLink(Args.Obj).Active;
end;

{ property Read ActiveRecord: Integer }
procedure TDataLink_Read_ActiveRecord(var Value: Variant; Args: TArguments);
begin
  Value := TDataLink(Args.Obj).ActiveRecord;
end;

{ property Write ActiveRecord(Value: Integer) }
procedure TDataLink_Write_ActiveRecord(const Value: Variant; Args: TArguments);
begin
  TDataLink(Args.Obj).ActiveRecord := Value;
end;

{ property Read BufferCount: Integer }
procedure TDataLink_Read_BufferCount(var Value: Variant; Args: TArguments);
begin
  Value := TDataLink(Args.Obj).BufferCount;
end;

{ property Write BufferCount(Value: Integer) }
procedure TDataLink_Write_BufferCount(const Value: Variant; Args: TArguments);
begin
  TDataLink(Args.Obj).BufferCount := Value;
end;

{ property Read DataSet: TDataSet }
procedure TDataLink_Read_DataSet(var Value: Variant; Args: TArguments);
begin
  Value := O2V(TDataLink(Args.Obj).DataSet);
end;

{ property Read DataSource: TDataSource }
procedure TDataLink_Read_DataSource(var Value: Variant; Args: TArguments);
begin
  Value := O2V(TDataLink(Args.Obj).DataSource);
end;

{ property Write DataSource(Value: TDataSource) }
procedure TDataLink_Write_DataSource(const Value: Variant; Args: TArguments);
begin
  TDataLink(Args.Obj).DataSource := V2O(Value) as TDataSource;
end;

{ property Read DataSourceFixed: Boolean }
procedure TDataLink_Read_DataSourceFixed(var Value: Variant; Args: TArguments);
begin
  Value := TDataLink(Args.Obj).DataSourceFixed;
end;

{ property Write DataSourceFixed(Value: Boolean) }
procedure TDataLink_Write_DataSourceFixed(const Value: Variant; Args: TArguments);
begin
  TDataLink(Args.Obj).DataSourceFixed := Value;
end;

{ property Read Editing: Boolean }
procedure TDataLink_Read_Editing(var Value: Variant; Args: TArguments);
begin
  Value := TDataLink(Args.Obj).Editing;
end;

{ property Read ReadOnly: Boolean }
procedure TDataLink_Read_ReadOnly(var Value: Variant; Args: TArguments);
begin
  Value := TDataLink(Args.Obj).ReadOnly;
end;

{ property Write ReadOnly(Value: Boolean) }
procedure TDataLink_Write_ReadOnly(const Value: Variant; Args: TArguments);
begin
  TDataLink(Args.Obj).ReadOnly := Value;
end;

{ property Read RecordCount: Integer }
procedure TDataLink_Read_RecordCount(var Value: Variant; Args: TArguments);
begin
  Value := TDataLink(Args.Obj).RecordCount;
end;

  { TDataSource }

{ constructor Create(AOwner: TComponent) }
procedure TDataSource_Create(var Value: Variant; Args: TArguments);
begin
  Value := O2V(TDataSource.Create(V2O(Args.Values[0]) as TComponent));
end;

{  procedure Edit; }
procedure TDataSource_Edit(var Value: Variant; Args: TArguments);
begin
  TDataSource(Args.Obj).Edit;
end;

{  function IsLinkedTo(DataSet: TDataSet): Boolean; }
procedure TDataSource_IsLinkedTo(var Value: Variant; Args: TArguments);
begin
  Value := TDataSource(Args.Obj).IsLinkedTo(V2O(Args.Values[0]) as TDataSet);
end;

{ property Read State: TDataSetState }
procedure TDataSource_Read_State(var Value: Variant; Args: TArguments);
begin
  Value := TDataSource(Args.Obj).State;
end;

{ property Read AutoEdit: Boolean }
procedure TDataSource_Read_AutoEdit(var Value: Variant; Args: TArguments);
begin
  Value := TDataSource(Args.Obj).AutoEdit;
end;

{ property Write AutoEdit(Value: Boolean) }
procedure TDataSource_Write_AutoEdit(const Value: Variant; Args: TArguments);
begin
  TDataSource(Args.Obj).AutoEdit := Value;
end;

{ property Read DataSet: TDataSet }
procedure TDataSource_Read_DataSet(var Value: Variant; Args: TArguments);
begin
  Value := O2V(TDataSource(Args.Obj).DataSet);
end;

{ property Write DataSet(Value: TDataSet) }
procedure TDataSource_Write_DataSet(const Value: Variant; Args: TArguments);
begin
  TDataSource(Args.Obj).DataSet := V2O(Value) as TDataSet;
end;

{ property Read Enabled: Boolean }
procedure TDataSource_Read_Enabled(var Value: Variant; Args: TArguments);
begin
  Value := TDataSource(Args.Obj).Enabled;
end;

{ property Write Enabled(Value: Boolean) }
procedure TDataSource_Write_Enabled(const Value: Variant; Args: TArguments);
begin
  TDataSource(Args.Obj).Enabled := Value;
end;

  { TCheckConstraint }

{  procedure Assign(Source: TPersistent); }
procedure TCheckConstraint_Assign(var Value: Variant; Args: TArguments);
begin
  TCheckConstraint(Args.Obj).Assign(V2O(Args.Values[0]) as TPersistent);
end;

{  function GetDisplayName: string; }
procedure TCheckConstraint_GetDisplayName(var Value: Variant; Args: TArguments);
begin
  Value := TCheckConstraint(Args.Obj).GetDisplayName;
end;

{ property Read CustomConstraint: string }
procedure TCheckConstraint_Read_CustomConstraint(var Value: Variant; Args: TArguments);
begin
  Value := TCheckConstraint(Args.Obj).CustomConstraint;
end;

{ property Write CustomConstraint(Value: string) }
procedure TCheckConstraint_Write_CustomConstraint(const Value: Variant; Args: TArguments);
begin
  TCheckConstraint(Args.Obj).CustomConstraint := Value;
end;

{ property Read ErrorMessage: string }
procedure TCheckConstraint_Read_ErrorMessage(var Value: Variant; Args: TArguments);
begin
  Value := TCheckConstraint(Args.Obj).ErrorMessage;
end;

{ property Write ErrorMessage(Value: string) }
procedure TCheckConstraint_Write_ErrorMessage(const Value: Variant; Args: TArguments);
begin
  TCheckConstraint(Args.Obj).ErrorMessage := Value;
end;

{ property Read FromDictionary: Boolean }
procedure TCheckConstraint_Read_FromDictionary(var Value: Variant; Args: TArguments);
begin
  Value := TCheckConstraint(Args.Obj).FromDictionary;
end;

{ property Write FromDictionary(Value: Boolean) }
procedure TCheckConstraint_Write_FromDictionary(const Value: Variant; Args: TArguments);
begin
  TCheckConstraint(Args.Obj).FromDictionary := Value;
end;

{ property Read ImportedConstraint: string }
procedure TCheckConstraint_Read_ImportedConstraint(var Value: Variant; Args: TArguments);
begin
  Value := TCheckConstraint(Args.Obj).ImportedConstraint;
end;

{ property Write ImportedConstraint(Value: string) }
procedure TCheckConstraint_Write_ImportedConstraint(const Value: Variant; Args: TArguments);
begin
  TCheckConstraint(Args.Obj).ImportedConstraint := Value;
end;

  { TCheckConstraints }

{ constructor Create(Owner: TPersistent) }
procedure TCheckConstraints_Create(var Value: Variant; Args: TArguments);
begin
  Value := O2V(TCheckConstraints.Create(V2O(Args.Values[0]) as TPersistent));
end;

{  function Add: TCheckConstraint; }
procedure TCheckConstraints_Add(var Value: Variant; Args: TArguments);
begin
  Value := O2V(TCheckConstraints(Args.Obj).Add);
end;

{ property Read Items[Integer]: TCheckConstraint }
procedure TCheckConstraints_Read_Items(var Value: Variant; Args: TArguments);
begin
  Value := O2V(TCheckConstraints(Args.Obj).Items[Args.Values[0]]);
end;

{ property Write Items[Integer]: TCheckConstraint }
procedure TCheckConstraints_Write_Items(const Value: Variant; Args: TArguments);
begin
  TCheckConstraints(Args.Obj).Items[Args.Values[0]] := V2O(Value) as TCheckConstraint;
end;

  {TParams}
  
// function ParamByName(const Value: string): TParam;
procedure TParams_ParamByName(var Value: Variant; Args: TArguments);
begin
  Value:=O2V(TParams(Args.Obj).ParamByName(Args.Values[0]));
end;

  { TDataSet }

{  function ActiveBuffer: PChar; }
procedure TDataSet_ActiveBuffer(var Value: Variant; Args: TArguments);
begin
  Value := string(PString(TDataSet(Args.Obj).ActiveBuffer));
end;

{  procedure Append; }
procedure TDataSet_Append(var Value: Variant; Args: TArguments);
begin
  TDataSet(Args.Obj).Append;
end;

{  procedure AppendRecord(const Values: array of const); }
{procedure TDataSet_AppendRecord(var Value: Variant; Args: TArguments);
begin
  Args.OpenArray(0);
  TDataSet(Args.Obj).AppendRecord(Slice(Args.OA^, Args.OAS));
end;}

{  function BookmarkValid(Bookmark: TBookmark): Boolean; }
procedure TDataSet_BookmarkValid(var Value: Variant; Args: TArguments);
begin
  Value := TDataSet(Args.Obj).BookmarkValid(V2P(Args.Values[0]));
end;

{  procedure Cancel; }
procedure TDataSet_Cancel(var Value: Variant; Args: TArguments);
begin
  TDataSet(Args.Obj).Cancel;
end;

{  procedure CheckBrowseMode; }
procedure TDataSet_CheckBrowseMode(var Value: Variant; Args: TArguments);
begin
  TDataSet(Args.Obj).CheckBrowseMode;
end;

{  procedure ClearFields; }
procedure TDataSet_ClearFields(var Value: Variant; Args: TArguments);
begin
  TDataSet(Args.Obj).ClearFields;
end;

{  procedure Close; }
procedure TDataSet_Close(var Value: Variant; Args: TArguments);
begin
  TDataSet(Args.Obj).Close;
end;

{  function ControlsDisabled: Boolean; }
procedure TDataSet_ControlsDisabled(var Value: Variant; Args: TArguments);
begin
  Value := TDataSet(Args.Obj).ControlsDisabled;
end;

{  function CompareBookmarks(Bookmark1, Bookmark2: TBookmark): Integer; }
procedure TDataSet_CompareBookmarks(var Value: Variant; Args: TArguments);
begin
  Value := TDataSet(Args.Obj).CompareBookmarks(V2P(Args.Values[0]), V2P(Args.Values[1]));
end;

{  function CreateBlobStream(Field: TField; Mode: TBlobStreamMode): TStream; }
procedure TDataSet_CreateBlobStream(var Value: Variant; Args: TArguments);
begin
  Value := O2V(TDataSet(Args.Obj).CreateBlobStream(V2O(Args.Values[0]) as TField, Args.Values[1]));
end;

{  procedure CursorPosChanged; }
procedure TDataSet_CursorPosChanged(var Value: Variant; Args: TArguments);
begin
  TDataSet(Args.Obj).CursorPosChanged;
end;

{  procedure Delete; }
procedure TDataSet_Delete(var Value: Variant; Args: TArguments);
begin
  TDataSet(Args.Obj).Delete;
end;

{  procedure DisableControls; }
procedure TDataSet_DisableControls(var Value: Variant; Args: TArguments);
begin
  TDataSet(Args.Obj).DisableControls;
end;

{  procedure Edit; }
procedure TDataSet_Edit(var Value: Variant; Args: TArguments);
begin
  TDataSet(Args.Obj).Edit;
end;

{  procedure EnableControls; }
procedure TDataSet_EnableControls(var Value: Variant; Args: TArguments);
begin
  TDataSet(Args.Obj).EnableControls;
end;

{  function FieldByName(const FieldName: string): TField; }
procedure TDataSet_FieldByName(var Value: Variant; Args: TArguments);
begin
  Value := O2V(TDataSet(Args.Obj).FieldByName(Args.Values[0]));
end;

{  function FindField(const FieldName: string): TField; }
procedure TDataSet_FindField(var Value: Variant; Args: TArguments);
begin
  Value := O2V(TDataSet(Args.Obj).FindField(Args.Values[0]));
end;

{  function FindFirst: Boolean; }
procedure TDataSet_FindFirst(var Value: Variant; Args: TArguments);
begin
  Value := TDataSet(Args.Obj).FindFirst;
end;

{  function FindLast: Boolean; }
procedure TDataSet_FindLast(var Value: Variant; Args: TArguments);
begin
  Value := TDataSet(Args.Obj).FindLast;
end;

{  function FindNext: Boolean; }
procedure TDataSet_FindNext(var Value: Variant; Args: TArguments);
begin
  Value := TDataSet(Args.Obj).FindNext;
end;

{  function FindPrior: Boolean; }
procedure TDataSet_FindPrior(var Value: Variant; Args: TArguments);
begin
  Value := TDataSet(Args.Obj).FindPrior;
end;

{  procedure First; }
procedure TDataSet_First(var Value: Variant; Args: TArguments);
begin
  TDataSet(Args.Obj).First;
end;

{  procedure FreeBookmark(Bookmark: TBookmark); }
procedure TDataSet_FreeBookmark(var Value: Variant; Args: TArguments);
begin
  TDataSet(Args.Obj).FreeBookmark(V2P(Args.Values[0]));
end;

{  function GetBookmark: TBookmark; }
procedure TDataSet_GetBookmark(var Value: Variant; Args: TArguments);
begin
  Value := P2V(TDataSet(Args.Obj).GetBookmark);
end;

{  function GetCurrentRecord(Buffer: PChar): Boolean; }
procedure TDataSet_GetCurrentRecord(var Value: Variant; Args: TArguments);
begin
  Value := TDataSet(Args.Obj).GetCurrentRecord(PChar(string(Args.Values[0])));
end;

{  procedure GetFieldList(List: TList; const FieldNames: string); }
procedure TDataSet_GetFieldList(var Value: Variant; Args: TArguments);
begin
  TDataSet(Args.Obj).GetFieldList(V2O(Args.Values[0]) as TList, Args.Values[1]);
end;

{  procedure GetFieldNames(List: TStrings); }
procedure TDataSet_GetFieldNames(var Value: Variant; Args: TArguments);
begin
  TDataSet(Args.Obj).GetFieldNames(V2O(Args.Values[0]) as TStrings);
end;

{  procedure GotoBookmark(Bookmark: TBookmark); }
procedure TDataSet_GotoBookmark(var Value: Variant; Args: TArguments);
begin
  TDataSet(Args.Obj).GotoBookmark(V2P(Args.Values[0]));
end;

{  procedure Insert; }
procedure TDataSet_Insert(var Value: Variant; Args: TArguments);
begin
  TDataSet(Args.Obj).Insert;
end;

{  procedure InsertRecord(const Values: array of const); }
{procedure TDataSet_InsertRecord(var Value: Variant; Args: TArguments);
begin
  Args.OpenArray(0);
  TDataSet(Args.Obj).InsertRecord(Slice(Args.OA^, Args.OAS));
end;}

{  function IsEmpty: Boolean; }
procedure TDataSet_IsEmpty(var Value: Variant; Args: TArguments);
begin
  Value := TDataSet(Args.Obj).IsEmpty;
end;

{  function IsLinkedTo(DataSource: TDataSource): Boolean; }
procedure TDataSet_IsLinkedTo(var Value: Variant; Args: TArguments);
begin
  Value := TDataSet(Args.Obj).IsLinkedTo(V2O(Args.Values[0]) as TDataSource);
end;

{  function IsSequenced: Boolean; }
procedure TDataSet_IsSequenced(var Value: Variant; Args: TArguments);
begin
  Value := TDataSet(Args.Obj).IsSequenced;
end;

{  procedure Last; }
procedure TDataSet_Last(var Value: Variant; Args: TArguments);
begin
  TDataSet(Args.Obj).Last;
end;

{  function Locate(const KeyFields: string; const KeyValues: Variant; Options: TLocateOptions): Boolean; }
procedure TDataSet_Locate(var Value: Variant; Args: TArguments);
begin
  Value := TDataSet(Args.Obj).Locate(Args.Values[0], Args.Values[1], TLocateOptions(Byte(V2S(Args.Values[2]))));
end;

{  function Lookup(const KeyFields: string; const KeyValues: Variant; const ResultFields: string): Variant; }
procedure TDataSet_Lookup(var Value: Variant; Args: TArguments);
begin
  Value := TDataSet(Args.Obj).Lookup(Args.Values[0], Args.Values[1], Args.Values[2]);
end;

{  function MoveBy(Distance: Integer): Integer; }
procedure TDataSet_MoveBy(var Value: Variant; Args: TArguments);
begin
  Value := TDataSet(Args.Obj).MoveBy(Args.Values[0]);
end;

{  procedure Next; }
procedure TDataSet_Next(var Value: Variant; Args: TArguments);
begin
  TDataSet(Args.Obj).Next;
end;

{  procedure Open; }
procedure TDataSet_Open(var Value: Variant; Args: TArguments);
begin
  TDataSet(Args.Obj).Open;
end;

{  procedure Post; }
procedure TDataSet_Post(var Value: Variant; Args: TArguments);
begin
  TDataSet(Args.Obj).Post;
end;

{  procedure Prior; }
procedure TDataSet_Prior(var Value: Variant; Args: TArguments);
begin
  TDataSet(Args.Obj).Prior;
end;

{  procedure Refresh; }
procedure TDataSet_Refresh(var Value: Variant; Args: TArguments);
begin
  TDataSet(Args.Obj).Refresh;
end;

{  procedure Resync(Mode: TResyncMode); }
procedure TDataSet_Resync(var Value: Variant; Args: TArguments);
begin
  TDataSet(Args.Obj).Resync(TResyncMode(Byte(V2S(Args.Values[0]))));
end;

{  procedure SetFields(const Values: array of const); }
{procedure TDataSet_SetFields(var Value: Variant; Args: TArguments);
begin
  Args.OpenArray(0);
  TDataSet(Args.Obj).SetFields(Slice(Args.OA^, Args.OAS));
end;}

{  procedure Translate(Src, Dest: PChar; ToOem: Boolean); }
procedure TDataSet_Translate(var Value: Variant; Args: TArguments);
begin
  TDataSet(Args.Obj).Translate(PChar(string(Args.Values[0])), PChar(string(Args.Values[1])), Args.Values[2]);
end;

{  procedure UpdateCursorPos; }
procedure TDataSet_UpdateCursorPos(var Value: Variant; Args: TArguments);
begin
  TDataSet(Args.Obj).UpdateCursorPos;
end;

{  procedure UpdateRecord; }
procedure TDataSet_UpdateRecord(var Value: Variant; Args: TArguments);
begin
  TDataSet(Args.Obj).UpdateRecord;
end;

{ property Read BOF: Boolean }
procedure TDataSet_Read_BOF(var Value: Variant; Args: TArguments);
begin
  Value := TDataSet(Args.Obj).BOF;
end;

{ property Read Bookmark: TBookmarkStr }
procedure TDataSet_Read_Bookmark(var Value: Variant; Args: TArguments);
begin
  Value := TDataSet(Args.Obj).Bookmark;
end;

{ property Write Bookmark(Value: TBookmarkStr) }
procedure TDataSet_Write_Bookmark(const Value: Variant; Args: TArguments);
begin
  TDataSet(Args.Obj).Bookmark := Value;
end;

{ property Read CanModify: Boolean }
procedure TDataSet_Read_CanModify(var Value: Variant; Args: TArguments);
begin
  Value := TDataSet(Args.Obj).CanModify;
end;

{ property Read DataSource: TDataSource }
procedure TDataSet_Read_DataSource(var Value: Variant; Args: TArguments);
begin
  Value := O2V(TDataSet(Args.Obj).DataSource);
end;

{ property Read DefaultFields: Boolean }
procedure TDataSet_Read_DefaultFields(var Value: Variant; Args: TArguments);
begin
  Value := TDataSet(Args.Obj).DefaultFields;
end;

{ property Read Designer: TDataSetDesigner }
procedure TDataSet_Read_Designer(var Value: Variant; Args: TArguments);
begin
  Value := O2V(TDataSet(Args.Obj).Designer);
end;

{ property Read EOF: Boolean }
procedure TDataSet_Read_EOF(var Value: Variant; Args: TArguments);
begin
  Value := TDataSet(Args.Obj).EOF;
end;

{ property Read FieldCount: Integer }
procedure TDataSet_Read_FieldCount(var Value: Variant; Args: TArguments);
begin
  Value := TDataSet(Args.Obj).FieldCount;
end;

{ property Read FieldDefs: TFieldDefs }
procedure TDataSet_Read_FieldDefs(var Value: Variant; Args: TArguments);
begin
  Value := O2V(TDataSet(Args.Obj).FieldDefs);
end;

{ property Write FieldDefs(Value: TFieldDefs) }
procedure TDataSet_Write_FieldDefs(const Value: Variant; Args: TArguments);
begin
  TDataSet(Args.Obj).FieldDefs := V2O(Value) as TFieldDefs;
end;

{ property Read Fields[Integer]: TField }
procedure TDataSet_Read_Fields(var Value: Variant; Args: TArguments);
begin
  Value := O2V(TDataSet(Args.Obj).Fields[Args.Values[0]]);
end;

{$IFNDEF RA_D4H}
{ property Write Fields[Integer]: TField }
procedure TDataSet_Write_Fields(const Value: Variant; Args: TArguments);
begin
  TDataSet(Args.Obj).Fields[Args.Values[0]] := V2O(Value) as TField;
end;
{$ENDIF RA_D4H}

{ property Read FieldValues[string]: Variant }
procedure TDataSet_Read_FieldValues(var Value: Variant; Args: TArguments);
begin
  Value := TDataSet(Args.Obj).FieldValues[Args.Values[0]];
end;

{ property Write FieldValues[string]: Variant }
procedure TDataSet_Write_FieldValues(const Value: Variant; Args: TArguments);
begin
  TDataSet(Args.Obj).FieldValues[Args.Values[0]] := Value;
end;

{ property Read Found: Boolean }
procedure TDataSet_Read_Found(var Value: Variant; Args: TArguments);
begin
  Value := TDataSet(Args.Obj).Found;
end;

{ property Read Modified: Boolean }
procedure TDataSet_Read_Modified(var Value: Variant; Args: TArguments);
begin
  Value := TDataSet(Args.Obj).Modified;
end;

{ property Read RecordCount: Integer }
procedure TDataSet_Read_RecordCount(var Value: Variant; Args: TArguments);
begin
  Value := TDataSet(Args.Obj).RecordCount;
end;

{ property Read RecNo: Integer }
procedure TDataSet_Read_RecNo(var Value: Variant; Args: TArguments);
begin
  Value := TDataSet(Args.Obj).RecNo;
end;

{ property Write RecNo(Value: Integer) }
procedure TDataSet_Write_RecNo(const Value: Variant; Args: TArguments);
begin
  TDataSet(Args.Obj).RecNo := Value;
end;

{ property Read RecordSize: Word }
procedure TDataSet_Read_RecordSize(var Value: Variant; Args: TArguments);
begin
  Value := TDataSet(Args.Obj).RecordSize;
end;

{ property Read State: TDataSetState }
procedure TDataSet_Read_State(var Value: Variant; Args: TArguments);
begin
  Value := TDataSet(Args.Obj).State;
end;

{ property Read Filter: string }
procedure TDataSet_Read_Filter(var Value: Variant; Args: TArguments);
begin
  Value := TDataSet(Args.Obj).Filter;
end;

{ property Write Filter(Value: string) }
procedure TDataSet_Write_Filter(const Value: Variant; Args: TArguments);
begin
  TDataSet(Args.Obj).Filter := Value;
end;

{ property Read Filtered: Boolean }
procedure TDataSet_Read_Filtered(var Value: Variant; Args: TArguments);
begin
  Value := TDataSet(Args.Obj).Filtered;
end;

{ property Write Filtered(Value: Boolean) }
procedure TDataSet_Write_Filtered(const Value: Variant; Args: TArguments);
begin
  TDataSet(Args.Obj).Filtered := Value;
end;

{ property Read FilterOptions: TFilterOptions }
procedure TDataSet_Read_FilterOptions(var Value: Variant; Args: TArguments);
begin
  Value := S2V(Byte(TDataSet(Args.Obj).FilterOptions));
end;

{ property Write FilterOptions(Value: TFilterOptions) }
procedure TDataSet_Write_FilterOptions(const Value: Variant; Args: TArguments);
begin
  TDataSet(Args.Obj).FilterOptions := TFilterOptions(Byte(V2S(Value)));
end;

{ property Read Active: Boolean }
procedure TDataSet_Read_Active(var Value: Variant; Args: TArguments);
begin
  Value := TDataSet(Args.Obj).Active;
end;

{ property Write Active(Value: Boolean) }
procedure TDataSet_Write_Active(const Value: Variant; Args: TArguments);
begin
  TDataSet(Args.Obj).Active := Value;
end;

{ property Read AutoCalcFields: Boolean }
procedure TDataSet_Read_AutoCalcFields(var Value: Variant; Args: TArguments);
begin
  Value := TDataSet(Args.Obj).AutoCalcFields;
end;

{ property Write AutoCalcFields(Value: Boolean) }
procedure TDataSet_Write_AutoCalcFields(const Value: Variant; Args: TArguments);
begin
  TDataSet(Args.Obj).AutoCalcFields := Value;
end;

// TClientDataSet

procedure TClientDataSet_CreateDataSet(var Value: Variant; Args: TArguments);
begin
  TClientDataSet(Args.Obj).CreateDataSet;
end;


procedure TClientDataSet_EmptyDataSet(var Value: Variant; Args: TArguments);
begin
  TClientDataSet(Args.Obj).EmptyDataSet;
end;

procedure TClientDataSet_SaveToFile(var Value: Variant; Args: TArguments);
begin
  TClientDataSet(Args.Obj).SaveToFile(Args.Values[0],Args.Values[1]);
end;

end.

