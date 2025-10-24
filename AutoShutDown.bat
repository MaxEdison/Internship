@REM  Automaticly Shutdown Windows in the given time
@REM  I just wanted to modify an existing Task, so you can use /Create command to create a new one.

schtasks /Change /RU "" /RP "12345678" /TN "YOUR SHUTDOWN TASK SCHEDUAL NAME" /ST HH:MM