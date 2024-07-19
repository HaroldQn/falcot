
</head>
<body>
    <div class="container-2">
        <table>
            <tr>
                <th>
                    <img class="logo" src="../images/logo.jpg" alt="FALCOT">
                </th>
                <th class="des-empresa">SOLUCIONES TECNOLOGICAS INDUSTRIALES FALCOT S.A.C
                        Direccion: Cal.Luis Galvez Ronceros NRO. 230 C.P. SANTA ROSA
                        Chincha - Chincha Baja
                        RUC:20610562176
                </th>
                <th class="border">
                    <h2>ORDEN DE COMPRA</h2>
                </th>
            </tr>
        </table>
        <table class="info-table top">
            <tr>
                <th class=" bold-text gr">SEÑORES:</th>
                <td colspan="2" class="pala""><?php echo htmlspecialchars($resultado[0]['cliente_razonSocial']); ?></td>
                <th class="bold-text gr">R.U.C.:</th>
                <td><?php echo htmlspecialchars($resultado[0]['cliente_ruc']); ?></td>
                <th class=" bold-text gr">MONEDA:</th>
                <td><?php echo htmlspecialchars($resultado[0]['moneda']); ?></td>
                <th class=" bold-text gr">N°:</th>
                <td>OR-00<?php echo htmlspecialchars($resultado[0]['idordencompra']); ?></td>
            </tr>
            <tr>
                <th class=" bold-text gr">DIRECCIÓN:</th>
                <td colspan="2" class="pala"><?php echo htmlspecialchars($resultado[0]['cliente_direccion']); ?></td>
                <th colspan="1" class="bold-text gr">CELULAR:</th>
                <td colspan="1"><?php echo htmlspecialchars($resultado[0]['cliente_celular']); ?></td>
                <th class=" bold-text gr">COND. PAGO:</th>
                <td>CONTADO</td>
                
                <th colspan="1" class=" bold-text gr">FECHA:</th>
                <td colspan="1"><?php echo htmlspecialchars($resultado[0]['fechaCreacion']); ?></td>
            </tr>
            <tr>
                <th colspan="3" class=" bold-text"></th>
                <th colspan="1" class=" bold-text gr">CORREO:</th>
                <td colspan="1" class="crece"><?php echo htmlspecialchars($resultado[0]['cliente_correo']); ?></td>
                <th colspan="1" class=" bold-text gr">CONTACTO:</th>
                <td colspan="1" class="crece2"><?php echo htmlspecialchars($resultado[0]['cliente_contacto']); ?></td>
                <th class=" bold-text gr">TELÉFONO:</th>
                <td colspan="1" class="crece3"><?php echo htmlspecialchars($resultado[0]['cliente_telefono']); ?></td>
            </tr>
        </table>
        <table class="items-table">
            <thead>
                <tr>
                    <th class="bold-text">ITEM</th>
                    <th class="bold-text">CENTRO</th>
                    <th class="descrip bold-text">DESCRIPCIÓN DE MATERIALES</th>
                    <th class="cantidad bold-text">CANTIDAD PEDIDA</th>
                    <th class="bold-text">UNID.</th>
                    <th class="bold-text">PRECIO UNITARIO</th>
                    <th class="bold-text">IMPORTE TOTAL</th>
                </tr>
            </thead>
            <tbody>
                <?php
                    if(count($detalle) === 0){
                        echo '<tr><td colspan="7">No hay registros</td></tr>';
                    }
                    else{
                        foreach($detalle as $i){
                            echo "
                            <tr>
                                <td>{$i['item']}</td>
                                <td>{$i['centro']}</td>
                                <td>{$i['descripcion']}</td>
                                <td>{$i['cantidad']}</td>
                                <td>{$i['utm']}</td>
                                <td>{$i['precioUnitario']}</td>
                                <td>{$i['total']}</td>
                            </tr>
                            ";
                        }
                    }
                ?>
            </tbody>
        </table>
        <table class="footer-info">
            <tr>
                <th class="bold-text gr">OBSERVACIONES:</th>
                <td class="nota" colspan="11"><?php echo htmlspecialchars($resultado[0]['observaciones']); ?></td>
                <th class="vacio no-bottom-border"></th>
                <th class="totales bold-text gr">SUBTOTAL:</th>
                <td class="resultado">S/ <?php echo htmlspecialchars($totales[0]['Subtotal']); ?></td>
            </tr>
            
            <tr>
                <th class="bold-text gr">CREADO POR:</th>
                <td class="creado" colspan="4">
                    <?php echo htmlspecialchars($resultado[0]['usuario_nombres']); ?>
                    <?php echo htmlspecialchars($resultado[0]['usuario_apellidos']); ?>
                </td>
                <th class="bold-text gr">DESTINO:</th>
                <td class="destino" colspan="6"><?php echo htmlspecialchars($resultado[0]['destino']); ?></td>
                <th class="no-bottom-border"></th>
                
                <th class="totales bold-text gr">IMPUESTO:</th>
                <td class="resultado">S/ <?php echo htmlspecialchars($totales[0]['IGV']); ?></td>
                
            </tr>
            <tr>
                <th class="bold-text gr">MONTO:</th>
                <td class="cabe" colspan="11"></td>
                <th class="no-bottom-border"></th>
                <th class="totales bold-text gr">DESCUENTO:</th>
                <td class="resultado">S/ <?php echo htmlspecialchars($totales[0]['Descuento']); ?></td>
            </tr>
            <tr>
                <td colspan="1" class="bold-text gr">NOTA:</td>
                <td colspan="11" class="nota">PRESENTAR COPIA DEL PRESENTE DOCUMENTO Y CONFORMIDAD AL MOMENTO DE PRESENTAR SU FACTURA</td>
                <th class=""></th>
                <th class="totales bold-text gr">TOTAL:</th>
                <td class="resultado">S/ <?php echo htmlspecialchars($totales[0]['Total']); ?></td>
            </tr>
        </table>
        <div class="footer">
            <p class="bold-text ">EL NÚMERO DE LA ORDEN DE COMPRA DEBE APARECER EN TODAS LAS FACTURAS Y CORRESPONDENCIA.</p>
        </div>
    </div>
</body>
</html>
