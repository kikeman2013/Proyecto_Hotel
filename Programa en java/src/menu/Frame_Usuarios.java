/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package menu;

import hotel.Frame_Menu;
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
public class Frame_Usuarios extends javax.swing.JFrame {
    Connection con = null;
    hotel.Inicio_sesion_Frame f;
    hotel.Frame_Menu fm;
    int select_row =0;
    int id_select =0;
    String nombre_select ;
    Vector columnas = new Vector();
    Vector fila     = new Vector();
    Vector datos    = new Vector();
    DefaultTableModel    modelo;
    /**
     * Creates new form Frame_Usuarios
     */
    public Frame_Usuarios() {
        initComponents();
    }
    public Frame_Usuarios(Connection _con , hotel.Inicio_sesion_Frame _f,hotel.Frame_Menu _fm) {
        initComponents();
        con=_con;
        f=_f;
        fm=_fm;
        ActualizarboxTipo();
        columnas.add( "ID" );
        columnas.add( "Nombre" );
        Actualizartabla();
        jLabel1.setVisible(false);
        jLabel3.setVisible(false);
        jLabel4.setVisible(false);
        jtxfPwd.setVisible(false);
        jtxfUser.setVisible(false);
        jbtnActualizar.setVisible(false);
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

    /**
     * This method is called from within the constructor to initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is always
     * regenerated by the Form Editor.
     */
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        jbtnRegistrarUsuario = new javax.swing.JButton();
        jbtnModificarUsuario = new javax.swing.JButton();
        jbtnEliminarUsuario = new javax.swing.JButton();
        jScrollPane1 = new javax.swing.JScrollPane();
        jtableUsuarios = new javax.swing.JTable();
        jLabel2 = new javax.swing.JLabel();
        jbtnRegresar = new javax.swing.JButton();
        jtxfUser = new javax.swing.JTextField();
        jLabel1 = new javax.swing.JLabel();
        jtxfPwd = new javax.swing.JPasswordField();
        jLabel3 = new javax.swing.JLabel();
        jbtnActualizar = new javax.swing.JButton();
        jcbxTipos = new javax.swing.JComboBox<>();
        jbntAgregar = new javax.swing.JButton();
        jLabel4 = new javax.swing.JLabel();
        labelFonfo = new javax.swing.JLabel();

        setDefaultCloseOperation(javax.swing.WindowConstants.DISPOSE_ON_CLOSE);
        setTitle("Usuarios");
        setIconImage(getIconImage());
        getContentPane().setLayout(new org.netbeans.lib.awtextra.AbsoluteLayout());

        jbtnRegistrarUsuario.setBackground(new java.awt.Color(51, 153, 0));
        jbtnRegistrarUsuario.setFont(new java.awt.Font("Arial", 0, 14)); // NOI18N
        jbtnRegistrarUsuario.setForeground(new java.awt.Color(255, 255, 255));
        jbtnRegistrarUsuario.setText("Registrar");
        jbtnRegistrarUsuario.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jbtnRegistrarUsuarioActionPerformed(evt);
            }
        });
        getContentPane().add(jbtnRegistrarUsuario, new org.netbeans.lib.awtextra.AbsoluteConstraints(10, 60, 110, 30));

        jbtnModificarUsuario.setBackground(new java.awt.Color(102, 153, 255));
        jbtnModificarUsuario.setFont(new java.awt.Font("Arial", 0, 14)); // NOI18N
        jbtnModificarUsuario.setForeground(new java.awt.Color(255, 255, 255));
        jbtnModificarUsuario.setText("Modificar");
        jbtnModificarUsuario.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jbtnModificarUsuarioActionPerformed(evt);
            }
        });
        getContentPane().add(jbtnModificarUsuario, new org.netbeans.lib.awtextra.AbsoluteConstraints(140, 60, 110, 30));

        jbtnEliminarUsuario.setBackground(new java.awt.Color(255, 102, 102));
        jbtnEliminarUsuario.setFont(new java.awt.Font("Arial", 0, 14)); // NOI18N
        jbtnEliminarUsuario.setForeground(new java.awt.Color(255, 255, 255));
        jbtnEliminarUsuario.setText("Eliminar");
        jbtnEliminarUsuario.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jbtnEliminarUsuarioActionPerformed(evt);
            }
        });
        getContentPane().add(jbtnEliminarUsuario, new org.netbeans.lib.awtextra.AbsoluteConstraints(270, 60, 110, 30));

        jtableUsuarios.setModel(new javax.swing.table.DefaultTableModel(
            new Object [][] {
                {null, null},
                {null, null},
                {null, null},
                {null, null}
            },
            new String [] {
                "ID", "Nombre"
            }
        ) {
            Class[] types = new Class [] {
                java.lang.Integer.class, java.lang.String.class
            };
            boolean[] canEdit = new boolean [] {
                false, false
            };

            public Class getColumnClass(int columnIndex) {
                return types [columnIndex];
            }

            public boolean isCellEditable(int rowIndex, int columnIndex) {
                return canEdit [columnIndex];
            }
        });
        jtableUsuarios.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                jtableUsuariosMouseClicked(evt);
            }
        });
        jScrollPane1.setViewportView(jtableUsuarios);

        getContentPane().add(jScrollPane1, new org.netbeans.lib.awtextra.AbsoluteConstraints(10, 110, 550, 164));

        jLabel2.setFont(new java.awt.Font("Century", 1, 36)); // NOI18N
        jLabel2.setForeground(new java.awt.Color(255, 255, 255));
        jLabel2.setText("Usuarios");
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
        getContentPane().add(jbtnRegresar, new org.netbeans.lib.awtextra.AbsoluteConstraints(480, 320, 110, 30));

        jtxfUser.setFont(new java.awt.Font("Arial", 0, 14)); // NOI18N
        getContentPane().add(jtxfUser, new org.netbeans.lib.awtextra.AbsoluteConstraints(10, 320, 100, -1));

        jLabel1.setFont(new java.awt.Font("Arial", 1, 14)); // NOI18N
        jLabel1.setText("Usuario:");
        getContentPane().add(jLabel1, new org.netbeans.lib.awtextra.AbsoluteConstraints(10, 300, -1, -1));

        jtxfPwd.setFont(new java.awt.Font("Arial", 0, 14)); // NOI18N
        getContentPane().add(jtxfPwd, new org.netbeans.lib.awtextra.AbsoluteConstraints(120, 320, 100, -1));

        jLabel3.setFont(new java.awt.Font("Arial", 1, 14)); // NOI18N
        jLabel3.setText("Contraseña:");
        getContentPane().add(jLabel3, new org.netbeans.lib.awtextra.AbsoluteConstraints(120, 300, -1, -1));

        jbtnActualizar.setBackground(new java.awt.Color(153, 255, 255));
        jbtnActualizar.setFont(new java.awt.Font("Arial", 0, 14)); // NOI18N
        jbtnActualizar.setText("Actualizar");
        jbtnActualizar.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jbtnActualizarActionPerformed(evt);
            }
        });
        getContentPane().add(jbtnActualizar, new org.netbeans.lib.awtextra.AbsoluteConstraints(230, 320, 110, 30));

        jcbxTipos.setFont(new java.awt.Font("Arial", 0, 14)); // NOI18N
        jcbxTipos.setModel(new javax.swing.DefaultComboBoxModel<>(new String[] { "Item 1", "Item 2", "Item 3", "Item 4" }));
        getContentPane().add(jcbxTipos, new org.netbeans.lib.awtextra.AbsoluteConstraints(10, 370, 140, -1));

        jbntAgregar.setBackground(new java.awt.Color(51, 153, 0));
        jbntAgregar.setFont(new java.awt.Font("Arial", 0, 14)); // NOI18N
        jbntAgregar.setForeground(new java.awt.Color(255, 255, 255));
        jbntAgregar.setText("Agregar");
        jbntAgregar.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jbntAgregarActionPerformed(evt);
            }
        });
        getContentPane().add(jbntAgregar, new org.netbeans.lib.awtextra.AbsoluteConstraints(360, 320, 110, 30));

        jLabel4.setFont(new java.awt.Font("Arial", 1, 14)); // NOI18N
        jLabel4.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        jLabel4.setText("Tipo:");
        getContentPane().add(jLabel4, new org.netbeans.lib.awtextra.AbsoluteConstraints(10, 350, 110, -1));
        getContentPane().add(labelFonfo, new org.netbeans.lib.awtextra.AbsoluteConstraints(0, 0, 600, 400));

        pack();
    }// </editor-fold>//GEN-END:initComponents

    private void jbtnRegistrarUsuarioActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jbtnRegistrarUsuarioActionPerformed
        jLabel1.setVisible(true);
        jLabel3.setVisible(true);
        jLabel4.setVisible(true);
        jtxfPwd.setVisible(true);
        jtxfUser.setVisible(true);
        jbtnActualizar.setVisible(false);
        jtxfUser.setText(""); 
        jtxfPwd.setText("");
        jcbxTipos.setVisible(true);
        jbntAgregar.setVisible(true);
    }//GEN-LAST:event_jbtnRegistrarUsuarioActionPerformed

    private void jbtnModificarUsuarioActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jbtnModificarUsuarioActionPerformed
        
        if(id_select!=0)
        {
         jLabel1.setVisible(true);
         jLabel3.setVisible(true);
         jtxfPwd.setVisible(true);
         jtxfUser.setVisible(true);
         jbntAgregar.setVisible(false);
         jcbxTipos.setVisible(false);
         jLabel4.setVisible(false);
         jbtnActualizar.setVisible(true);
         jtxfUser.setText(nombre_select); 
         jtxfPwd.setText("");
        }
        else{
        JOptionPane.showMessageDialog(this,"No has seleccionado un usuario para modificar","No seleccion", JOptionPane.INFORMATION_MESSAGE);
        }
    }//GEN-LAST:event_jbtnModificarUsuarioActionPerformed

    private void jbtnEliminarUsuarioActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jbtnEliminarUsuarioActionPerformed
    if(id_select!=0)
        {
        try {
            String sql = "call eliminar_usuario("+id_select+")";
            Statement ps = con.createStatement();
            ps.executeUpdate(sql);
            ps.close(); 
            f.actulizar_sesion();
        } catch (Exception e) {
            System.out.println( e );
        }
        Actualizartabla();
        
        }
    else{
        JOptionPane.showMessageDialog(this,"No has seleccionado un usuario para Eliminar","No seleccion", JOptionPane.INFORMATION_MESSAGE);
        }    
        jLabel1.setVisible(false);
        jLabel3.setVisible(false);
        jLabel4.setVisible(false);
        jtxfPwd.setVisible(false);
        jtxfUser.setVisible(false);
        jbtnActualizar.setVisible(false);
        jbntAgregar.setVisible(false);
        jcbxTipos.setVisible(false);
    }//GEN-LAST:event_jbtnEliminarUsuarioActionPerformed

    private void jbtnRegresarActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jbtnRegresarActionPerformed
    fm.setVisible(true);
    this.dispose();
    }//GEN-LAST:event_jbtnRegresarActionPerformed

    private void jtableUsuariosMouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jtableUsuariosMouseClicked
         select_row = jtableUsuarios.getSelectedRow();
         id_select = Integer.parseInt(jtableUsuarios.getValueAt(select_row, 0).toString());
         nombre_select = jtableUsuarios.getValueAt(select_row, 1).toString();
    }//GEN-LAST:event_jtableUsuariosMouseClicked

    private void jbtnActualizarActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jbtnActualizarActionPerformed
        if(!jtxfUser.getText().trim().equals("")||!jtxfPwd.getText().trim().equals("")){
       String nombre = jtxfUser.getText();
       String pwd = jtxfPwd.getText();
       if(pwd.equals(""))
           pwd = "vacio";
        try {        
             String sql = "call actualizar_usuario('"+nombre+"','"+pwd+"',"+id_select+")"; 
             Statement ps = con.createStatement();
             ps.executeUpdate(sql);
             ps.close(); 

        } catch (Exception e) {
            System.out.println( e );
        }
        jLabel1.setVisible(false);
        jLabel3.setVisible(false);
        jLabel4.setVisible(false);
        jcbxTipos.setVisible(false);
        jtxfPwd.setText("");
        jtxfPwd.setVisible(false);
        jtxfUser.setText("");
        jtxfUser.setVisible(false);
        jbtnActualizar.setVisible(false);    
        Actualizartabla();
        f.actulizar_sesion();
        }
        else{
        JOptionPane.showMessageDialog(this,
                    "Se necesitan llenar todos los campos",
                    "  Campos vacios", HEIGHT);
        }
    }//GEN-LAST:event_jbtnActualizarActionPerformed

    private void jbntAgregarActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jbntAgregarActionPerformed
        if(!jtxfUser.getText().trim().equals("")&&!jtxfPwd.getText().trim().equals("")){
        String user =jtxfUser.getText();
        String pwd = jtxfPwd.getText();
        String select = jcbxTipos.getSelectedItem().toString();
        try {
            String sql = "call registrar_usuario('"+user+"','"+pwd+"','"+select+"','"+f.cadena+"')";
            Statement ps = con.createStatement();
            ps.executeUpdate(sql);
            ps.close();

        } catch (Exception e) {
            System.out.println("ERROR:" + e);
        }
        jLabel1.setVisible(false);
        jLabel3.setVisible(false);
        jLabel4.setVisible(false);
        jcbxTipos.setVisible(false);
        jtxfPwd.setText("");
        jtxfPwd.setVisible(false);
        jtxfUser.setText("");
        jtxfUser.setVisible(false);
        jbtnActualizar.setVisible(false);
        f.actulizar_sesion();
        Actualizartabla();   
        }
        else{
        JOptionPane.showMessageDialog(this,
                    "Se necesitan llenar todos los campos",
                    "  Campos vacios", HEIGHT);
        }
    }//GEN-LAST:event_jbntAgregarActionPerformed

    
    public void Actualizartabla()   
    {
    try {
       
        String sql = "SELECT usr_id , usr_login FROM usuarios ORDER BY usr_id";
        PreparedStatement ps = con.prepareStatement( sql );
        ResultSet rs = ps.executeQuery();
        datos.removeAllElements();
        while (rs.next()){
                int    ID      = rs.getInt     ( "usr_id" );
                String nombre = rs.getString  ( "usr_login" );
        fila = new Vector ();
        fila.add( ID );
        fila.add( nombre );
        
        datos.add( fila );
        }
        modelo = new DefaultTableModel(datos, columnas);
        jtableUsuarios.setModel(modelo);
    } catch (Exception ex) {System.out.println(ex);
    }
    }
    
    public  void ActualizarboxTipo(){
     try {       
        String sql = "SELECT rol_nombre FROM roles";
        PreparedStatement ps = con.prepareStatement( sql );
        ResultSet rs = ps.executeQuery();
        jcbxTipos.removeAllItems();
        while (rs.next()){
                String    nombre      = rs.getString     ( 1 );       
        jcbxTipos.addItem(nombre);
        }
            
    } catch (Exception ex) {System.out.println(""+ex);}
    }

    /**
     * @param args the command line arguments
     */
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
            java.util.logging.Logger.getLogger(Frame_Usuarios.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (InstantiationException ex) {
            java.util.logging.Logger.getLogger(Frame_Usuarios.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (IllegalAccessException ex) {
            java.util.logging.Logger.getLogger(Frame_Usuarios.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (javax.swing.UnsupportedLookAndFeelException ex) {
            java.util.logging.Logger.getLogger(Frame_Usuarios.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        }
        //</editor-fold>

        /* Create and display the form */
        java.awt.EventQueue.invokeLater(new Runnable() {
            public void run() {
                new Frame_Usuarios().setVisible(true);
            }
        });
    }

    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JLabel jLabel1;
    private javax.swing.JLabel jLabel2;
    private javax.swing.JLabel jLabel3;
    private javax.swing.JLabel jLabel4;
    private javax.swing.JScrollPane jScrollPane1;
    private javax.swing.JButton jbntAgregar;
    private javax.swing.JButton jbtnActualizar;
    private javax.swing.JButton jbtnEliminarUsuario;
    private javax.swing.JButton jbtnModificarUsuario;
    private javax.swing.JButton jbtnRegistrarUsuario;
    private javax.swing.JButton jbtnRegresar;
    private javax.swing.JComboBox<String> jcbxTipos;
    private javax.swing.JTable jtableUsuarios;
    private javax.swing.JPasswordField jtxfPwd;
    private javax.swing.JTextField jtxfUser;
    private javax.swing.JLabel labelFonfo;
    // End of variables declaration//GEN-END:variables
}