Current limitations.
====================

1) Only Win32 platform is supported. Later will be added Linux support.

2) GUIx layer (all AnyDAC GUI related stuffs) is not yet ported.

3) Moni layer (all AnyDAC monitoring / tracing facilities) is not yet ported.

4) Design-time property editors, component editors are not yet ported.

5) Utilities are not yet ported.

Known issues
============

1) You can edit TADDataSet descendants, but updates will be not posted 
to DB due to FPC compiler bug. It erroneously calls IADDaptTableAdapter.Reset
method instead of Update and backward.

2) DBGrid displays MSSQL money field value with more than 4 digits after
decimal separator. This is due to rounding error in FPC FloatToStrF function.

