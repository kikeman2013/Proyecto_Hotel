/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package menu;

import java.awt.Image;
import java.awt.Toolkit;
import javax.swing.Icon;
import javax.swing.ImageIcon;
import javax.swing.WindowConstants;

/**
 *
 * @author ebelm
 */
public class Frame_AcercaDe extends javax.swing.JFrame {

    /**
     * Creates new form Frame_AcercaDe
     */
    public Frame_AcercaDe() {
        initComponents();
        setDefaultCloseOperation(WindowConstants.DISPOSE_ON_CLOSE);
        setSize(420, 455);
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

        jLabel7 = new javax.swing.JLabel();
        jlblLogoTec = new javax.swing.JLabel();
        jlblAutor2 = new javax.swing.JLabel();
        jlblAutor3 = new javax.swing.JLabel();
        jlblAutor4 = new javax.swing.JLabel();
        jlblTecMexico = new javax.swing.JLabel();
        jLabel1 = new javax.swing.JLabel();
        jLabel2 = new javax.swing.JLabel();
        jLabel3 = new javax.swing.JLabel();
        jlblNombreApp = new javax.swing.JLabel();
        jLabel5 = new javax.swing.JLabel();
        jlblAutor1 = new javax.swing.JLabel();
        labelFonfo = new javax.swing.JLabel();

        setDefaultCloseOperation(javax.swing.WindowConstants.EXIT_ON_CLOSE);
        setTitle("Acerca de");
        setIconImage(getIconImage());
        getContentPane().setLayout(new org.netbeans.lib.awtextra.AbsoluteLayout());

        jLabel7.setText("(C) Derechos reservados 2019");
        getContentPane().add(jLabel7, new org.netbeans.lib.awtextra.AbsoluteConstraints(120, 380, -1, -1));

        jlblLogoTec.setIcon(new javax.swing.ImageIcon(getClass().getResource("/imagenes/240px-ITL.png"))); // NOI18N
        jlblLogoTec.setText(" ");
        getContentPane().add(jlblLogoTec, new org.netbeans.lib.awtextra.AbsoluteConstraints(20, 20, 100, 100));

        jlblAutor2.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        jlblAutor2.setText("André Salvador Ochoa Martínez.    17130813");
        getContentPane().add(jlblAutor2, new org.netbeans.lib.awtextra.AbsoluteConstraints(130, 330, 268, -1));

        jlblAutor3.setFont(new java.awt.Font("Agency FB", 1, 18)); // NOI18N
        jlblAutor3.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        jlblAutor3.setText("Taller de Base de Datos");
        getContentPane().add(jlblAutor3, new org.netbeans.lib.awtextra.AbsoluteConstraints(60, 200, 268, 30));

        jlblAutor4.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        jlblAutor4.setText(" ");
        getContentPane().add(jlblAutor4, new org.netbeans.lib.awtextra.AbsoluteConstraints(130, 300, 268, -1));

        jlblTecMexico.setIcon(new javax.swing.ImageIcon(getClass().getResource("/imagenes/Logo-TecNM-2017.png"))); // NOI18N
        jlblTecMexico.setText(" ");
        getContentPane().add(jlblTecMexico, new org.netbeans.lib.awtextra.AbsoluteConstraints(20, 250, 105, 90));

        jLabel1.setFont(new java.awt.Font("Arial", 1, 14)); // NOI18N
        jLabel1.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        jLabel1.setText("TECNOLOGICO NACIONAL DE MEXICO");
        getContentPane().add(jLabel1, new org.netbeans.lib.awtextra.AbsoluteConstraints(120, 30, 290, -1));

        jLabel2.setFont(new java.awt.Font("Arial", 1, 14)); // NOI18N
        jLabel2.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        jLabel2.setText("Instituto Tecnologico de La Laguna");
        getContentPane().add(jLabel2, new org.netbeans.lib.awtextra.AbsoluteConstraints(130, 70, 280, -1));

        jLabel3.setFont(new java.awt.Font("Arial", 1, 18)); // NOI18N
        jLabel3.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        jLabel3.setText("Ingenieria en Sistemas Computacionales");
        getContentPane().add(jLabel3, new org.netbeans.lib.awtextra.AbsoluteConstraints(10, 130, 400, -1));

        jlblNombreApp.setFont(new java.awt.Font("Tahoma", 1, 14)); // NOI18N
        jlblNombreApp.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        jlblNombreApp.setText("Proyecto Final ");
        jlblNombreApp.setHorizontalTextPosition(javax.swing.SwingConstants.CENTER);
        getContentPane().add(jlblNombreApp, new org.netbeans.lib.awtextra.AbsoluteConstraints(70, 170, 260, 20));

        jLabel5.setText("Desarrollado por:");
        getContentPane().add(jLabel5, new org.netbeans.lib.awtextra.AbsoluteConstraints(130, 250, -1, -1));

        jlblAutor1.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        jlblAutor1.setText("Enrique Antonio Belmarez Meraz    17130765");
        getContentPane().add(jlblAutor1, new org.netbeans.lib.awtextra.AbsoluteConstraints(130, 280, 268, -1));
        getContentPane().add(labelFonfo, new org.netbeans.lib.awtextra.AbsoluteConstraints(0, 0, 420, 450));

        pack();
    }// </editor-fold>//GEN-END:initComponents

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
            java.util.logging.Logger.getLogger(Frame_AcercaDe.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (InstantiationException ex) {
            java.util.logging.Logger.getLogger(Frame_AcercaDe.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (IllegalAccessException ex) {
            java.util.logging.Logger.getLogger(Frame_AcercaDe.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (javax.swing.UnsupportedLookAndFeelException ex) {
            java.util.logging.Logger.getLogger(Frame_AcercaDe.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        }
        //</editor-fold>

        /* Create and display the form */
        java.awt.EventQueue.invokeLater(new Runnable() {
            public void run() {
                new Frame_AcercaDe().setVisible(true);
            }
        });
    }

    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JLabel jLabel1;
    private javax.swing.JLabel jLabel2;
    private javax.swing.JLabel jLabel3;
    private javax.swing.JLabel jLabel5;
    private javax.swing.JLabel jLabel7;
    private javax.swing.JLabel jlblAutor1;
    private javax.swing.JLabel jlblAutor2;
    private javax.swing.JLabel jlblAutor3;
    private javax.swing.JLabel jlblAutor4;
    private javax.swing.JLabel jlblLogoTec;
    private javax.swing.JLabel jlblNombreApp;
    private javax.swing.JLabel jlblTecMexico;
    private javax.swing.JLabel labelFonfo;
    // End of variables declaration//GEN-END:variables
}
