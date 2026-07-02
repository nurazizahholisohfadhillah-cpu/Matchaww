<?php

header('Content-Type:application/json');
header('Access-Control_Allow-Original:*');
header('Access-Control_Allow-Method:GET,POST');
 $connect = mysqli_connect('localhost','root','','finansial');

 if (!$connect) {
    die("koneksi gagal: " . mysqli_connect_error());
    # code...
 }
if ($_SERVER['REQUEST_METHOD'] == 'GET') {
    //ambil data dari database
    $sql = 'select * from catatan_finansial';
    mysqli_query($connect,$sql);
    $result = mysqli_query($connect, $sql);

    //konversi ke json lalu kirim sebagai response
    $data = array();
    while ($row = mysqli_fetch_assoc($result)) {
        $data [] = $row;
    }
    echo json_encode ($data);
    # code...
} elseif ($_SERVER['REQUEST_METHOD']=='POST') {
    // membaca json yang di post oleh client
    $input = json_decode(file_get_contents('php://input'), true);

    // ambil nominal dan kategori:
    $nominal =$input['nominal'];
    $kategori = $input['kategori'];

    //insert nominal dan kategori ke database (tabel catatan_finansial)
    $sql = "INSERT INTO catatan_finansial (nominal, kategori) VALUES ('$nominal', '$kategori')";
    $result = mysqli_query($connect,$sql);
    
    if ($result) {
        echo json_encode(array('status' =>  'sukses', 'message' => 'Data berhasil ditambahkan'));
    } else {
        echo json_encode(array('status' => 'gagal','message' => mysqli_error($connect)));
    }
}
elseif ($_SERVER['REQUEST_METHOD']=='PUT'){

    $input=json_decode(file_get_contents("php://input"),true);

    $id=$input['id'];
    $nominal=$input['nominal'];
    $kategori=$input['kategori'];

    $sql="UPDATE catatan_finansial
          SET nominal='$nominal',
              kategori='$kategori'
          WHERE id='$id'";

    $result=mysqli_query($connect,$sql);

    if($result){
        echo json_encode(array(
            "status"=>"sukses"
        ));
    }else{
        echo json_encode(array(
            "status"=>"gagal"
        ));
    }
}

elseif ($_SERVER['REQUEST_METHOD']=='DELETE'){

    $input=json_decode(file_get_contents("php://input"),true);

    $id=$input['id'];

    $sql="DELETE FROM catatan_finansial WHERE id='$id'";

    $result=mysqli_query($connect,$sql);

    if($result){
        echo json_encode(array(
            "status"=>"sukses"
        ));
    }else{
        echo json_encode(array(
            "status"=>"gagal"
        ));
    }
}

?>