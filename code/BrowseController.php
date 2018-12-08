<?php

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 * Description of BrowseController
 *
 * @author Adi Surya
 */
class BrowseController extends Controller {

  public static $url_handlers = array(
      '$Action//$ID/$OtherID' => 'handleAction',
          //'$Action/$ID/$OtherID' => 'handleAction'
          //#'$ClassName/#ID' => 'handleItem',
          //#'$ClassName' => 'handleList',
  );
  private static $allowed_actions = array(
      'test',
      'testajax',
      'window',
      'windowajax',
  );
  
  function init() {
    parent::init();
    $base = 'adis-browse';
    Requirements::css($base . '/css/browse.css');
		Requirements::javascript($base . '/js/jquery-2.2.5.min.js');
  }

  //put your code here
  function index() {
    //var_dump($_REQUEST);
    return $this->renderWith(array('BrowseIndex', 'Page'));
  }
  
  function test(){
    echo 'test';
    var_dump($this->request->allParams());
  }
  
  function testajax(){
    echo 'test';
  }

  function getConfigColumns($config){
      //$config = 'Customer';
      $columns = array();
      
      if($config == 'Customer'){
        $columns = array(
            array(
                'Column' => 'ID',
                'Type' => 'Number'
            ),
            array(
                'Column' => 'LastEdited',
                'Type' => 'Date',
                'Required' => false
            ),
            array(
                'Column' => 'Title',
                'Type' => 'Text',
                'Required' => false
            ),
            array(
                'Column' => 'Content',
                'Type' => 'Text',
                'Required' => false
            ),
            array(
                'Column' => 'Price',
                'Type' => 'Number',
                'Required' => false
            )
        );       
      }
      elseif($config == 'Team'){
        $columns = array(
            array(
                'Column' => 'LastEdited',
                'Type' => 'Date',
                'Required' => false
            ),
            array(
                'Column' => 'Sort',
                'Type' => 'Number',
                'Required' => false
            ),
            array(
                'Column' => 'Name',
                'Type' => 'Text',
                'Required' => false
            ),
            array(
                'Column' => 'Title',
                'Type' => 'Text',
                'Required' => false
            )
        );           
      }
      return $columns;
    }

    function window(){
      $config = 'Customer';
      if($this->request->param('ID')){
        $config = $this->request->param('ID');
      }
      $columns = $this->getConfigColumns($config);
      
      return $this->customise(array(
          'Columns' => new ArrayList($columns),
          'BrowseConfig' => $config
      ))->renderWith('BrowserWindow');
    }
    
    function windowajax(){
      $config = 'Customer';
      if($this->request->param('ID')){
        $config = $this->request->param('ID');       
      }      
      $limit = isset($_REQUEST['count']) && $_REQUEST['count'] ? $_REQUEST['count'] : 10;      
      $sorting = isset($_REQUEST['sorting']) ? $_REQUEST['sorting'] : 'ID';
      $sorting_direction = isset($_REQUEST['sorting_direction']) ? $_REQUEST['sorting_direction'] : 'ASC';
      $order = "$sorting $sorting_direction";      
      $where = "";
      if(isset($_REQUEST['filter']) && count($_REQUEST['filter']) && isset($_REQUEST['keyword']) && count($_REQUEST['keyword'])){
        foreach($_REQUEST['filter'] as $idx => $filter){
          // jika ada keyword / tdk kosong
          if($_REQUEST['keyword'][$idx]){            
            if($_REQUEST['filter_operator'][$idx] == 'contain'){
              $temp_where = " AND $filter like '%".$_REQUEST['keyword'][$idx]."%' ";
            }
            elseif($_REQUEST['filter_operator'][$idx] == 'start'){
              $temp_where = " AND $filter like '".$_REQUEST['keyword'][$idx]."%' ";
            }
            else{
              $temp_where = " AND $filter ".$_REQUEST['filter_operator'][$idx]." '".$_REQUEST['keyword'][$idx]."' ";
            }
            $where .= $temp_where;
          }
        }
      }
      $columns = $this->getConfigColumns($config);
      //var_dump($columns);
      
      if($config == 'Customer'){        
        $sql = "select * 
                from CustomerData
                where ID>0 $where
                order by $order  
                limit $limit
                ";
        $result = DB::query($sql);        
      }
      elseif($config == 'Team'){        
        $sql = "select * 
                from TeamData
                where ID>0 $where
                order by $order  
                limit $limit
                ";
        $result = DB::query($sql);        
      }
      
      $arr_result = array();
      foreach($result as $row){
        // isi row sesuai array dari columns
        $temp = array();
        foreach($columns as $idx => $col){
          $temp[$col['Column']] = $row[$col['Column']];
        }
        $arr_result[] = $temp;
      }     
      //echo '<pre>';var_dump($arr_result);
      return json_encode($arr_result);
    }
}
