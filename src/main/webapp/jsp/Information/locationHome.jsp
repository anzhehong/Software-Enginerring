<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.camplus.entity.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<script charset="utf-8" src="http://map.qq.com/api/js?v=2.exp&key=d84d6d83e0e51e481e50454ccbe8986b"></script>

<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Shuttle | Camplus</title>
    <!-- bootstrap css -->
    <link href="/camplus/external/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <!-- bootstrap js -->
    <script src="/camplus/external/jQuery/jquery-1.11.3.min.js"></script>
    <script src="/camplus/external/bootstrap/js/bootstrap.min.js"></script>
    <!-- custom -->
    <link rel="stylesheet" type="text/css" href="/camplus/css/navbar.css">
    <link rel="stylesheet" type="text/css" href="/camplus/css/shuttle.css">

    <script charset="utf-8" src="http://map.qq.com/api/js?v=2.exp"></script>
    <script>

    window.onload = function(){
    //直接加载地图
    var geocoder,map,marker = null;
        //初始化地图函数  自定义函数名init
        function init() {
            var center = new qq.maps.LatLng(31.2855741398, 121.2147781261)
            //定义map变量 调用 qq.maps.Map() 构造函数   获取地图显示容器
            var map = new qq.maps.Map(document.getElementById("container"), {
                center: center,      // 地图的中心地理坐标。
                zoom:15
            });

            //创建marker
            var marker = new qq.maps.Marker({
                position: center,
                map: map
            });
            //添加到提示窗
            var info = new qq.maps.InfoWindow({
                map: map
            });
            //获取标记的点击事件
            qq.maps.event.addListener(marker, 'click', function() {
                info.open(); 
                info.setContent('<div style="text-align:center;white-space:nowrap;margin:10px;">Tongji University</div>');
                info.setPosition(center); 
            });

            geocoder = new qq.maps.Geocoder({
                complete : function(result){
                    map.setCenter(result.detail.location);
                    var marker = new qq.maps.Marker({
                        map:map,
                        position: result.detail.location
                    });
                }
            });
            // 创建街景
            var pano = new qq.maps.Panorama(document.getElementById('pano_holder'), {
                pano: '10011001120129111239600',
                disableMove: false,
                pov:{
                    heading:20,
                    pitch:15
                },
                disableFullScreen:false,
                zoom:1
            });
            pano_service = new qq.maps.PanoramaService();

            // 地图点击事件
            qq.maps.event.addListener(map, 'click', function (evt){
                var point = evt.latLng;
                var radius;
                pano_service.getPano(point, radius, function (result){
                    pano.setPano(result.svid);
                });
                var scroll_offset = $("#pano_holder").offset();
                $("html, body").animate({
                    scrollTop: scroll_offset.top
                }, "slow");
            });
        }
        //调用初始化函数地图
        init();
    }
    </script>

</head>
<body>
   <div class="navbar navbar-inverse">
        <div class="container">
            <div class="navbar-header">
                <button type="button" class="navbar-toggle collapsed" data-toggle="collapse"
                        data-target="#navbar" aria-expanded="false" aria-controls="navbar">
                    <span class="sr-only">Toggle navigation</span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                </button>
                <a class="navbar-brand" href=""></a>
            </div>
            <div class="collapse navbar-collapse" id="navbar">
                <!-- TODO: 这里要添加所有标签的URL -->
                <ul class="nav navbar-nav">
                    <li ><a href="/camplus/jsp/index.jsp">Home</a></li>
                    <li><a href="<c:url value="/carpool/select"></c:url>">Carpool</a></li>
                    <li><a href="/camplus/jsp/CourseDiscussion/courseSearch.jsp">Course</a></li>
                    <li class="dropdown">
                        <a href="#" data-toggle="dropdown">Gallery<span class="caret"></span></a>
                        <ul class="dropdown-menu">
                            <li><a href="<c:url value="/gallery"></c:url>">Album</a></li>
                            <li><a href="<c:url value="/gallery/hotComment"></c:url>">Hot</a></li>
                            <li><a href="<c:url value="/gallery/mySpace"></c:url>">My space</a></li>
                        </ul>
                    </li>
                    <li class="dropdown">
                        <a href="#" data-toggle="dropdown">Information<span class="caret"></span></a>
                        <ul class="dropdown-menu">
                            <li class="active"><a href="<c:url value="/information/locationHome"></c:url>">Map</a></li>
                            <li><a href="<c:url value="/restaurant"></c:url> ">Take Out</a></li>
                            <li><a href="<c:url value="/information/busTimeHome"></c:url>">Shuttle</a></li>
                        </ul>
                    </li>
                </ul>

          <%
                  User currentUser = (User)session.getAttribute("userSession");
                  String userName = currentUser.getUserName();
          %>


                <ul class="nav navbar-nav navbar-right">
                    <!-- TODO: 这里要处理一下session，现在注释的部分是没有登录的 -->
                   <!-- <button type="button" onclick="signup()" class="btn btn-signup navbar-btn">Sign up</button>
                    <button type="button" onclick="signin()" class="btn btn-signin navbar-btn">Sign in</button>-->
                     <li><a href="<c:url value="/user/editInfo"></c:url>"><%=userName%></a></li>
                    <li><a href="<c:url value="/logout"></c:url>"><span class="glyphicon glyphicon-log-out" aria-hidden="true"></span></a></li> 
                </ul>
            </div>
        </div>
    </div>
    <div class="container" onLoad="init()">
        <div class="page-header text-center">
            <h1 class="text-center">Planimetric Map</h1>
            <p>Click on annotation of map to view the street map. Have fun!</p>
        </div>
        <div class="panel panel-success">
            <div class="panel-body">
                <div id="container"></div>
            </div>
        </div>
        
        <hr>
        <div class="text-center">
            <h1>Street Map</h1>
            <p>Enjoy the beautiful scene you want to see!</p>
            <br>
            <!-- <div id="pano_holder"></div> -->
        </div>
        <div class="panel panel-success">
            <div class="panel-body">
                <div id="pano_holder"></div>
            </div>
        </div>
    </div>
    
    <hr>
    <footer class="home-footer">
        <div class="home-footer-text">
            <p>Address: 4800 Cao An Road, Jiading District, Shanghai</p>
            <p>email: Fowafolo@gmail.com</p>
            <p>&copy; 2015-2016  &middot; <a href="home">Camplus</a> &middot; All rights reserved.</p>
        </div>
    </footer>
    <script src="http://map.qq.com/api/js?v=2.exp&key=d84d6d83e0e51e481e50454ccbe8986b"></script>
</body>
</html>