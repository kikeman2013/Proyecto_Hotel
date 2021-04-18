/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package menu;

import java.awt.Image;
import java.awt.Toolkit;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.Vector;
import javax.swing.Icon;
import javax.swing.ImageIcon;
import javax.swing.JOptionPane;
import javax.swing.table.DefaultTableModel;

/**
 *
 * @author ebelm
 */
public class Frame_habitaciones extends javax.swing.JFrame {
    Connection con = null;
    hotel.Inicio_sesion_Frame f;
    hotel.Frame_Menu fm;
    int select_row=0;
    int codigo_selec;
    String tipo_selec;
    Vector columnas = new Vector();
    Vector fila     = new Vector();
    Vector datos    = new Vector();
    DefaultTableModel    modelo;
    /**
     * Creates new form Frame_habitaciones
     */
    public Frame_habitaciones() {
        initComponents();
    }
    public Frame_habitaciones(Connection _con , hotel.Inicio_sesion_Frame _f, hotel.Frame_Menu _fm) {
        initComponents();
        con=_con;
        f=_f;
        fm=_fm;
        ActualizarboxTipo();
        columnas.add( "Codigo" );
        columnas.add( "Tipo" );
        columnas.add( "Capacidad" );
        columnas.add( "Precio" );
        columnas.add("Disponibilidad");
        Actualizartabla();
        jLabel4.setVisible(false);
        jbntAgregar.setVisible(false);
        jcbxTipos.setVisible(false);
        
        ImageIcon wallpaper = new ImageIcon("src/imagenes/wallpaperPrincipal.jpg");
        Icon icono = new ImageIcon(wallpaper.getImage().getScaledInstance(labelFonfo.getWidth(),
                labelFonfo.getHeight(), Image.SCALE_DEFAULT));
        labelFonfo.setIcon(icono);
        this.repaint();
    }
    
    @Override
    public Image getIconImage(){
        Image retValue = Toolkit.getDefaultToolkit().getImage(ClassLoader.getSystemResource("imagenes/Emojin.png"));
        return  retValue;
    }
    
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        jcbxTipos = new javax.swing.JComboBox<>();
        jbtnEliminar = new javax.swing.JButton();
        jbntAgregar = new javax.swing.JButton();
        jScrollPane1 = new javax.swing.JScrollPane();
        jtableHabitaciones = new javax.swing.JTable();
        jLabel2 = new javax.swing.JLabel();
        jbtnRegresar = new javax.swing.JButton();
        jbtnRegistrar = new javax.swing.JButton();
        jLabel4 = new javax.swing.JLabel();
        labelFonfo = new javax.swing.JLabel();

        setDefaultCloseOperation(javax.swing.WindowConstants.DISPOSE_ON_CLOSE);
        setTitle("Habitaciones");
        setIconImage(getIconImage());
        getContentPane().setLayout(new org.netbeans.lib.awtextra.AbsoluteLayout());

        jcbxTipos.setFont(new java.awt.Font("Arial", 0, 14)); // NOI18N
        jcbxTipos.setModel(new javax.swing.DefaultComboBoxModel<>(new String[] { "Item 1", "Item 2", "Item 3", "Item 4" }));
        getContentPane().add(jcbxTipos, new org.netbeans.lib.awtextra.AbsoluteConstraints(20, 300, 90, -1));

        jbtnEliminar.setBackground(new java.awt.Color(255, 102, 102));
        jbtnEliminar.setFont(new java.awt.Font("Arial", 0, 14)); // NOI18N
        jbtnEliminar.setForeground(new java.awt.Color(255, 255, 255));
        jbtnEliminar.setText("Eliminar");
        jbtnEliminar.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jbtnEliminarActionPerformed(evt);
            }
        });
        getContentPane().add(jbtnEliminar, new org.netbeans.lib.awtextra.AbsoluteConstraints(140, 60, 110, 30));

        jbntAgregar.setBackground(new java.awt.Color(51, 153, 0));
        jbntAgregar.setFont(new java.awt.Font("Arial", 0, 14)); // NOI18N
        jbntAgregar.setForeground(new java.awt.Color(255, 255, 255));
        jbntAgregar.setText("Agregar");
        jbntAgregar.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jbntAgregarActionPerformed(evt);
            }
        });
        getContentPane().add(jbntAgregar, new org.netbeans.lib.awtextra.AbsoluteConstraints(140, 300, 110, 30));

        jtableHabitaciones.setModel(new javax.swing.table.DefaultTableModel(
            new Object [][] {
                {null, null, null, null, null},
                {null, null, null, null, null},
                {null, null, null, null, null},
                {null, null, null, null, null}
            },
            new String [] {
                "Codigo", "Tipo", "Capacidad", "Precio", "Disponiblidad"
            }
        ) {
            Class[] types = new Class [] {
                java.lang.Integer.class, java.lang.String.class, java.lang.Integer.class, java.lang.Integer.class, java.lang.String.class
            };
            boolean[] canEdit = new boolean [] {
                false, false, false, false, false
            };

            public Class getColumnClass(int columnIndex) {
                return types [columnIndex];
            }

            public boolean isCellEditable(int rowIndex, int columnIndex) {
                return canEdit [columnIndex];
            }
        });
        jtableHabitaciones.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                jtableHabitacionesMouseClicked(evt);
            }
        });
        jScrollPane1.setViewportView(jtableHabitaciones);

        getContentPane().add(jScrollPane1, new org.netbeans.lib.awtextra.AbsoluteConstraints(12, 102, 710, 164));

        jLabel2.setFont(new java.awt.Font("Century", 1, 36)); // NOI18N
        jLabel2.setForeground(new java.awt.Color(255, 255, 255));
        jLabel2.setText("Habitacion");
        jLabel2.setToolTipText("titulo");
        getContentPane().add(jLabel2, new org.netbeans.lib.awtextra.AbsoluteConstraints(12, 13, -1, -1));

        jbtnRegresar.setBackground(new java.awt.Color(255, 102, 102));
        jbtnRegresar.setFont(new java.awt.Font("Arial", 0, 14)); // NOI18N
        jbtnRegresar.setForeground(new java.awt.Color(255, 255, 255));
        jbtnRegresar.setText("Regresar");
        jbtnRegresar.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jbtnRegresarActionPerformed(evt);
            }
        });
        getContentPane().add(jbtnRegresar, new org.netbeans.lib.awtextra.AbsoluteConstraints(630, 300, 110, 30));

        jbtnRegistrar.setBackground(new java.awt.Color(51, 153, 0));
        jbtnRegistrar.setFont(new java.awt.Font("Arial", 0, 14)); // NOI18N
        jbtnRegistrar.setForeground(new java.awt.Color(255, 255, 255));
        jbtnRegistrar.setText("Registrar");
        jbtnRegistrar.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jbtnRegistrarActionPerformed(evt);
            }
        });
        getContentPane().add(jbtnRegistrar, new org.netbeans.lib.awtextra.AbsoluteConstraints(12, 60, 110, 30));

        jLabel4.setFont(new java.awt.Font("Arial", 1, 14)); // NOI18N
        jLabel4.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        jLabel4.setText("Tipo:");
        getContentPane().add(jLabel4, new org.netbeans.lib.awtextra.AbsoluteConstraints(20, 280, 90, -1));
        getContentPane().add(labelFonfo, new org.netbeans.lib.awtextra.AbsoluteConstraints(0, 0, 750, 370));

        pack();
    }// </editor-fold>//GEN-END:initComponents

    private void jbtnEliminarActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jbtnEliminarActionPerformed
    if(select_row!=0){ 
        
        try {        
             String sql = "call eliminar_habitacion("+codigo_selec+")"; 
             Statement ps = con.createStatement();
             ps.executeUpdate(sql);
             ps.close(); 

        } catch (Exception e) {
            System.out.println( e );
        }  
        Actualizartabla();
        f.actulizar_sesion();
    }
    else{
    JOptionPane.showMessageDialog(this,"No has seleccionado una Habitacion para Eliminar","No seleccion", JOptionPane.INFORMATION_MESSAGE);
    }
    }//GEN-LAST:event_jbtnEliminarActionPerformed

    private void jbntAgregarActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jbntAgregarActionPerformed
        String tipo = jcbxTipos.getSelectedItem().toString();
        
        try {        
             String sql = "call agregar_habitacion('"+tipo+"')"; 
             Statement ps = con.createStatement();
             ps.executeUpdate(sql);
             ps.close(); 

        } catch (Exception e) {
            System.out.println( e );
        }  
        Actualizartabla();
        jLabel4.setVisible(false);
        jcbxTipos.setVisible(false);
        jbntAgregar.setVisible(false);
        f.actulizar_sesion();
    }//GEN-LAST:event_jbntAgregarActionPerformed

    private void jtableHabitacionesMouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jtableHabitacionesMouseClicked
         select_row = jtableHabitaciones.getSelectedRow();
         codigo_selec = Integer.parseInt(jtableHabitaciones.getValueAt(select_row, 0).toString());
         tipo_selec = jtableHabitaciones.getValueAt(select_row, 1).toString();
         
    }//GEN-LAST:event_jtableHabitacionesMouseClicked

    private void jbtnRegresarActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jbtnRegresarActionPerformed
    fm.setVisible(true);
    this.dispose();
    }//GEN-LAST:event_jbtnRegresarActionPerformed

    private void jbtnRegistrarActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jbtnRegistrarActionPerformed
        jLabel4.setVisible(true);
        jbntAgregar.setVisible(true);
        jcbxTipos.setVisible(true);
        
    }//GEN-LAST:event_jbtnRegistrarActionPerformed
    public void Actualizartabla()   
    {
    try {
       
        String sql = "SELECT * FROM vActhab";
        PreparedStatement ps = con.prepareStatement( sql );
        ResultSet rs = ps.executeQuery();
        datos.removeAllElements();
        while (rs.next()){
                int    codigo       = rs.getInt     ( "hab_codigo" );
                String nombre       = rs.getString  ( "tip_hab_descripcion" );
                int    capacidad    = rs.getInt     ( "tip_hab_capacidad" );
                int    precio       = rs.getInt     ( "tip_hab_precio" );
                String    d = rs.getString("hab_disponible" );
                
        fila = new Vector ();
        fila.add( codigo );
        fila.add( nombre );
        fila.add( capacidad );
        fila.add( precio );
        fila.add(d);
        
        datos.add( fila );
        }
        modelo = new DefaultTableModel(datos, columnas);
        jtableHabitaciones.setModel(modelo);
    } catch (Exception ex) {System.out.println(ex);
    }
    }
     public  void ActualizarboxTipo(){
     try {       
        String sql = "SELECT tip_hab_descripcion FROM tipo_habitacion";
        PreparedStatement ps = con.prepareStatement( sql );
        ResultSet rs = ps.executeQuery();
        jcbxTipos.removeAllItems();
        while (rs.next()){
                String    nombre      = rs.getString     ( 1 );       
        jcbxTipos.addItem(nombre);
        }
            
    } catch (Exception ex) {System.out.println(""+ex);}
    }
    public static void main(String args[]) {
        /* Set the Nimbus look and feel */
        //<editor-fold defaultstate="collapsed" desc=" Look and feel setting code (optional) ">
        /* If Nimbus (introduced in Java SE 6) is not available, stay with the default look and feel.
         * For details see http://download.oracle.com/javase/tutorial/uiswing/lookandfeel/plaf.html 
         */
        try {
            for (javax.swing.UIManager.LookAndFeelInfo info : javax.swing.UIManager.getInstalledLookAndFeels()) {
                if ("Nimbus".equals(info.getName())) {
                    javax.swing.UIManager.setLookAndFeel(info.getClassName());
                    break;
                }
            }
        } catch (ClassNotFoundException ex) {
            java.util.logging.Logger.getLogger(Frame_habitaciones.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (InstantiationException ex) {
            java.util.logging.Logger.getLogger(Frame_habitaciones.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (IllegalAccessException ex) {
            java.util.logging.Logger.getLogger(Frame_habitaciones.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (javax.swing.UnsupportedLookAndFeelException ex) {
            java.util.logging.Logger.getLogger(Frame_habitaciones.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        }
        //</editor-fold>

        /* Create and display the form */
        java.awt.EventQueue.invokeLater(new Runnable() {
            public void run() {
                new Frame_habitaciones().setVisible(true);
            }
        });
    }

    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JLabel jLabel2;
    private javax.swing.JLabel jLabel4;
    private javax.swing.JScrollPane jScrollPane1;
    private javax.swing.JButton jbntAgregar;
    private javax.swing.JButton jbtnEliminar;
    private javax.swing.JButton jbtnRegistrar;
    private javax.swing.JButton jbtnRegresar;
    private javax.swing.JComboBox<String> jcbxTipos;
    private javax.swing.JTable jtableHabitaciones;
    private javax.swing.JLabel labelFonfo;
    // End of variables declaration//GEN-END:variables
}
