from PyInstaller.utils.hooks import collect_data_files

hiddenimports = ['vispy.app.backends._pyside2']

datas = collect_data_files('vispy')
