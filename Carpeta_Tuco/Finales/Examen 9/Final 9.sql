DECLARE curEjer2 cursor
FOR
	SELECT IDEmpleado, SUM(severidad)
	FROM AUSENTISMO 
	WHERE YEAR(FechaFalta) = 2007
	GROUP BY IDEmplado 

OPEN cursor curEjer1 

DECLARE @idemp char(5), @sev int
FETCH next
	FROM curEjer2
	INTO @idemp, @sev

while( @@FETCH_STATUS = 0)
begin	
	BEGIN TRANSACTION
	IF (40< @sev)
	begin
		DELETE EMPLEADO WHERE IDEmp = @idemp
		DELETE AUSENTISMO WHERE IDEmpleado = @idemp --DELETE AUSENTISMO WHERE CURRENT OF AUSENTISMO
	end

	IF (@@ERROR = 0) COMMIT TRANSACTION
	ELSE ROLLBACK TRANSACTION

	FETCH next
	FROM curEjer1
	INTO @idemp, @sev
end
close curEjer2
deallocate curEjer2